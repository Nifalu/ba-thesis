#import "@preview/cetz:0.4.1": *

#let draw-node(node, parent: none) = {
  // For now, let's just return a simple circle with text
  // This should work with the tree API
  ((
    circle(radius: 1cm, fill: white, stroke: black),
  ),)
}

// Function to draw edges with labels
#let draw-edge(from, to, target-node) = {
  // Simple line between nodes
  (line((from, to), stroke: black),)
}
