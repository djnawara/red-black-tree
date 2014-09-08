require "graphviz"
require "red_black_tree"
require "red_black_tree/node"

class RedBlackTree
  module Visualizer
    OUTPUT_FILE = "tree.pdf".freeze

    class << self
      def draw(tree, output_file = OUTPUT_FILE)
        graph = Graphviz::Graph.new
        add_all_to_graph(graph, tree.root)
        Graphviz::output(graph, path: output_file)

        output_file
      end

      private

      def add_all_to_graph(graph, tree_node)
        graph_node = graph.add_node(tree_node.get_label)
        tree_node.black? ? set_black(graph_node) : set_red(graph_node)

        add_all_to_graph(graph_node, tree_node.left_child) if tree_node.has_left_child?
        add_all_to_graph(graph_node, tree_node.right_child) if tree_node.has_right_child?
      end

      def set_black(graph)
        graph.attributes.update({
          fillcolor: "black",
          style: "filled",
          fontcolor: "white"
        })
      end

      def set_red(graph)
        graph.attributes.update({
          fillcolor: "red",
          style: "filled",
          fontcolor: "white"
        })
      end
    end
  end
end
