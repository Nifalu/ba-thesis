import itertools
import re
import angr
from math import factorial
from angr import SimState, SimulationManager
from analyzer.InputHooks import InputHookRegistry
from analyzer.OutputChecker import setup_output_checker
from analyzer.CANSim import Component, Message
from analyzer.io_state import IOState
from utils.logger import logger
log = logger(__name__)

class MCSAnalyser:

    def __init__(self, component: Component, run_with_unconstrained_inputs: bool = False, count_inputs = False):
        self.component: Component = component
        self.run_with_unconstrained_inputs = run_with_unconstrained_inputs
        self.proj = angr.Project(self.component.path, auto_load_libs=False)
        self.cfg = self.proj.analyses.CFGEmulated()
        self.current_input_iterator = None
        self.current_input_list = None
        self.output_addrs = None
        self.output_checker = None
        self.input_hook_registry: InputHookRegistry = InputHookRegistry()
        self.count_inputs = count_inputs


    def analyse(self) -> None:
        log.info(f"Analysing {self.component}")
        input_addrs = self._find_addr(self.component.config().input_hooks)
        log.info(f"Input Functions {[(name, hex(addr)) for addr, name in input_addrs.items()]}")
        entry_points = self._get_sim_states(input_addrs.keys())
        self.output_addrs = self._find_addr(self.component.config().output_hooks)
        log.info(f"Output Functions {[(name, hex(addr)) for addr, name in self.output_addrs.items()]}")
        self.output_checker = setup_output_checker(str(self.component.path), self.output_addrs)

        for addr, func_name in input_addrs.items():
            if not self.proj.is_hooked(addr):
                hook = self.input_hook_registry.create_hook(func_name, self.yield_input)
                self.proj.hook(addr, hook)
                log.debug(f"Hooked {func_name} at {hex(addr)} with {hook.__class__.__name__}")

        if self.run_with_unconstrained_inputs:
            log.info(f"Running with unconstrained inputs on {len(entry_points)} entry points")
            self._run_analysis(entry_points)
        else:
            input_combinations = self._generate_input_combinations(
                self.component.read_all(),
                length=self.component.expected_inputs)
            for combination in input_combinations:
                self.current_input_list = list(self._flatten_combinations(combination))
                self._run_analysis(entry_points)


    def _run_analysis(self, entry_points: list[SimState]) -> None:
        for entry_point in entry_points:
            entry_point_copy = entry_point.copy()
            if not self.run_with_unconstrained_inputs:
                self.current_input_iterator = iter(self.current_input_list)

            entry_point_copy.inspect.b(
                'call',
                when=angr.BP_BEFORE,
                action=lambda state: self.output_checker.check_output(state, self.output_addrs.keys(), self.store_result_callback)
            )
            simgr: SimulationManager = self.proj.factory.simgr(entry_point_copy)

            log.debug(f"Finding all solutions from {entry_point_copy.addr:#x}")

            simgr.explore(
                find=list(self.output_addrs.keys()),
                cfg=self.cfg,
                num_find=10,
            )

            log.debug(f"Found {len(simgr.found)} solutions")

            #self._get_sim_states(self.output_addrs.values(), ep_copy)

    def store_result_callback(self, dest: IOState, msg_data: IOState) -> None:
        self.component.send(Message(self.component.id, dest, msg_data))

    def yield_input(self):
        """
        A Hook for the Hook to retrieve the next input.
        :return:
        """
        if self.count_inputs:
            self.component.expected_inputs += 1
        try:
            if self.run_with_unconstrained_inputs:
                return IOState.unconstrained(f"input_{self.component.path}", self.component.config().default_var_length)
            return next(self.current_input_iterator)
        except StopIteration:
            log.error("Requested more inputs than available... => Creating unconstrained input")
            return IOState.unconstrained(f"{self.component.path}_unconstrained", self.component.config().default_var_length)

    def _find_addr(self, names: list[str]):
        """
        Find addresses of functions matching the given names.
        :param names:
        :return:
        """
        escaped_names = [re.escape(name) for name in names]
        pattern = re.compile("|".join(escaped_names))

        log.debug(f"Finding addresses of functions matching pattern {pattern}")
        found = {}

        for func in self.cfg.kb.functions.values():
            if func.name and pattern.search(func.name):
                section = self.proj.loader.find_section_containing(func.addr)
                if section and section.is_executable:
                    log.debug(f"Found {func.name} at {hex(func.addr)}")
                    normalized_name = InputHookRegistry.normalize_function_name(func.name)
                    found[func.addr] = normalized_name
                else:
                    log.debug(f"Ignoring {func.name} at {hex(func.addr)} as it is not executable. Probably a GOT entry")
        if not found:
            log.warning(f"No addresses found for {pattern}")
        return found

    def _get_sim_states(self, addrs, entry_point: SimState=None) -> list[SimState]:
        """
        Explore the CFG and retrieve the SimStates of the given addresses
        :param addrs:
        :return:
        """
        NUM_FIND = 10_000

        initial_state: SimState = self.proj.factory.entry_state() if entry_point is None else entry_point
        simgr: SimulationManager = self.proj.factory.simgr(initial_state)

        log.debug(f"Getting SimStates for {[hex(x) for x in addrs]}")

        simgr.explore(find=list(addrs), num_find=NUM_FIND, cfg=self.cfg)
        if not simgr.found:
            log.error("Could not reach any addresses")
            return list()
        else:
            n = len(simgr.found)
            if n == NUM_FIND:
                log.warning(f"Hit the maximum number of solutions ({n}), consider increasing the 'NUM_FIND' parameter.")
            log.debug(f"Found {len(simgr.found)} SimStates for {[hex(x) for x in addrs]}")
            return simgr.found


    def _generate_input_combinations(self, inputs: list[Message], allow_repetition=False, length=None, warn_threshold=100):
        """
        Lazily generates all possible permutations of the inputs.

        Args:
            inputs: List of available inputs
            allow_repetition: Whether to allow selecting the same input multiple times (default: False)
            length: Length of permutations to generate (default: len(inputs))
            warn_threshold: Number of combinations above which to print a warning

        Yields:
            Lists representing permutations of the inputs

        Raises:
            ValueError: If length > len(inputs) and allow_repetition=False
        """
        n = len(inputs)
        k = length if length is not None else n

        # Validate
        if not allow_repetition and k > n:
            raise ValueError(f"Cannot generate permutations of length {k} from {n} inputs without repetition.")

        # Calculate total combinations
        if allow_repetition:
            total_combinations = n ** k
        else:
            total_combinations = factorial(n) // factorial(n - k)

        log.info(f"Generated {total_combinations} input combinations of length {length} to analyze")

        if total_combinations > warn_threshold:
            log.warning(f"Large number of input combinations to check: {total_combinations:,} combinations!")

        # Generate permutations
        if allow_repetition:
            # Use product for permutations with repetition
            yield from itertools.product(inputs, repeat=k)
        else:
            # Use permutations for permutations without repetition
            yield from itertools.permutations(inputs, k)


    @staticmethod
    def _flatten_combinations(combination: tuple[Message, ...] | tuple[Message, Message]):
        for c in combination:
            yield c.dest      # Yield destination IOState
            yield c.msg_data  # Yield data IOState