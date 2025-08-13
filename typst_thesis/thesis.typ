// #import "@local/dmi-basilea-thesis:0.1.1": *
#import "@local/dmi-basilea-thesis:0.1.1": *
// or for local testing:
// #import "../src/main.typ": *  // This is for local testing


#show: thesis.with(
  colored: true,
  title: [Multi-Component System \ Analysis using \ Symbolic Execution],
  author: "Nico Bachmann",
  email: "nico@nifalu.ch",
  immatriculation: "2021-050-059",
  supervisor: "Prof. Dr. Christopher Scherb",
  examiner: "Dr. Marco Vogt",
  faculty: "Faculty of Science, University of Basel",
  department: "Department of Mathematics and Computer Science",
  research-group: "Databases and Information Systems (DBIS) Group",
  website: "https://dbis.dmi.unibas.ch",
  thesis-type: "Bachelor Thesis",
  date: datetime.today(),
  language: "en",
  body-font: "Crimson Pro",
  body-size: 11pt,
  sans-font: "Open Sans",
  mono-font: "Ubuntu Mono",
  mono-size: 10pt,
  draft: false,

  abstract: [
  Modern safety-critical systems in the fields of aeronautics, automotive engineering and industrial automation consist of numerous interconnected components that communicate via message-passing protocols such as CAN. Such multi-component systems (MCS) are becoming more complex, quickly exceeding the human ability to comprehend all possible interactions and failure modes. While all individual components may work as intended, their interactions can still produce potentially dangerous or catastrophic behaviour as tragically demonstrated by recent aviation accidents. This thesis presents an automated approach to analysing communication paths in MCS through symbolic execution. We have developed MCS Analyser, a tool built on the angr binary analysis framework that extracts information about the components, simulates message exchanges and constructs a graph displaying the found communication paths. The tool requires minimal human configuration and no access to source code. By systematically analysing all possible input combinations and tracking the resulting outputs for each component, MCS Analyser reveals the actual communication between components. Evaluation with Dr. Mischa Jahn, a security specialist in the aeronautics industry, confirms the tool's practical utility in getting an overview of a systems behaviour in a field where only few people have a deep understanding of the entire system and even fewer have security expertise. He suggested future extensions, such as probability calculations for path exploitation and simulating the effects of specific paths on the system itself. While the current implementation has limitations including path explosion and other constraints inherent to symbolic execution, it provides a valuable foundation for further research and development in this area.
  ],

  acknowledgments: [ 
  Firstly, I would like to thank my supervisor, Prof. Dr. Christopher Scherb for his guidance and support throughout this project, providing valuable insight and feedback and taking the time to review and discuss my work. I would also like to thank Dr. Marco Vogt for the opportunity to write this thesis with an external supervisor. A big thank you goes to Dr. Mischa Jahn for participating in the expert interview, providing valuable insights and expertise on the topic of safety and security in aeronautics. Without them, this thesis would not have been possible. Finally, I would like to thank Ruben, for convincing me to join the software security lecture which ultimately led to writing this thesis, Lina for her continuous support and encouragement throughout the project and #link("https://open.spotify.com/album/3OT6k1ifjAOirGAlpQCkNK?si=9HmNBq8lQo24U3HmMkxkqQ")[_Schrotthagen_] for providing me with banger music to work to. 
  ],

  chapters: (
    include "content/introduction.typ",
    include "content/background.typ",
    include "content/methodology.typ",
    include "content/implementation/implementation.typ",
    include "content/evaluation.typ",
    include "content/discussion.typ",
    include "content/conclusion.typ",
    include "content/future_work.typ",
    include "content/ai_notice.typ"
  ),

  appendices: (),

  bibliography-content: bibliography("references.bib", style: "ieee", title: none),
)
