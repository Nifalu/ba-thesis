#import "@preview/dmi-basilea-thesis:0.1.0": *
// or for local testing:
// #import "../src/main.typ": *  // This is for local testing

#show: thesis.with(
  colored: true,
  title: "Drawing Attack Graphs for Multi-Component Systems",
  author: "Nico Bachmann",
  email: "nico@nifalu.ch",
  immatriculation: "2020-123-456",
  supervisor: "Prof. Dr. Christopher Scherb",
  examiner: "Dr. Marco Vogt",
  faculty: "Faculty of Science, University of Basel",
  department: "Department of Mathematics and Computer Science",
  research-group: "Databases and Information Systems (DBIS) Group",
  website: "https://dbis.dmi.unibas.ch",
  thesis-type: "Bachelor Thesis",
  date: datetime.today(),
  language: "en",
  body-font: "Libre Baskerville",
  sans-font: "Open Sans",
  mono-font: "Ubuntu Mono",
  draft: true,

  abstract: [
    #todo-missing("Write abstract")
  ],

  acknowledgments: [
    #todo-missing("Thank the cool people")
  ],

  chapters: (
    include "content/introduction.typ",
    include "content/background.typ",
    include "content/methodology.typ",
    include "content/implementation.typ",
    include "content/evaluation.typ",
    include "content/discussion.typ",
    include "content/conclusion.typ",
    include "content/future_work.typ",
    include "content/related_work.typ",
    include "content/ai_notice.typ"
  ),

  appendices: (
    include "content/appendix.typ",
  ),

  bibliography-content: bibliography("references.bib", style: "ieee", title: none),
)
