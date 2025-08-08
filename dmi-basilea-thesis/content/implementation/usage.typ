#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm

== Usage

The tool was developed with minimal human input in mind to reduce the chance of misleading outputs caused by usage-errors. Correspondingly simple is the usage:

*Prerequisites:* Clone the repository and install make sure to have a working Python environment with the packages listed in the `requirements.txt` installed. The tool was developed and tested with Python 3.13.

*Steps to run the MCS Analyser:*
1. Prepare a *`config.json`* that contains information on which input and output functions to track, the directory in which the component binaries are located as well as the binary filename of each component. Optionally a name and description can be provided which greatly increases the readability of the resulting graph.

2. Run the *MCS Analyser* with the following command:
```bash
python main.py --config <config.json>
```

3. View the resulting graph on #link("http://localhost:8080")[`http://localhost:8080`]

#figure(pad(
```json
{
  "var_length": 64,
  "input_hooks": ["scanf"],
  "output_hooks": ["printf"],
  "components_dir": "./bin/cesna",
  "components": [
    {
      "name": "Speed Sensor",
      "filename": "c1_speed_sensor",
      "description": "Produces speed readings"
    }
  ]
}
```,
  10pt),
  caption: "Example configuration file for the MCS Analyser"
)

#todo-missing("Create some better design for code blocks")
#todo-missing("Decide how to handle the schnauzer visualisation...")
