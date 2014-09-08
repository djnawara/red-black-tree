require "red_black_tree/visualizer"

class RedBlackTree
  describe Visualizer do
    TEST_OUTPUT_FILE = File.expand_path("../../../test.pdf", __FILE__).freeze

    after(:each) do
      File.delete(TEST_OUTPUT_FILE) if File.exists?(TEST_OUTPUT_FILE)
    end

    describe ".draw" do
      it "makes a graph for rendering" do
        graph_spy = instance_spy(Graphviz::Graph)
        allow(graph_spy).to receive(:attributes).and_return({})
        allow(graph_spy).to receive(:add_node).and_return(graph_spy)

        tree = RedBlackTree.new
        tree.insert(Node.new(0))

        expect(Graphviz::Graph).to receive(:new).once.and_return(graph_spy)

        Visualizer.draw(tree, TEST_OUTPUT_FILE)
      end

      it "adds all nodes of the tree to the graph" do
        graph_spy = instance_spy(Graphviz::Graph)
        allow(graph_spy).to receive(:attributes).and_return({})
        allow(graph_spy).to receive(:add_node).and_return(graph_spy)

        root = RedBlackTree::Node.new(10)
        parent = RedBlackTree::Node.new(5)
        uncle = RedBlackTree::Node.new(15)
        child = RedBlackTree::Node.new(0)

        tree = RedBlackTree.new
        tree.insert(root)
        tree.insert(parent)
        tree.insert(uncle)
        tree.insert(child)

        expect(Graphviz::Graph).to receive(:new).once.and_return(graph_spy)

        expect(graph_spy).to receive(:add_node).with(root.get_label).once.and_return(graph_spy)
        expect(graph_spy).to receive(:add_node).with(parent.get_label).once.and_return(graph_spy)
        expect(graph_spy).to receive(:add_node).with(uncle.get_label).once.and_return(graph_spy)
        expect(graph_spy).to receive(:add_node).with(child.get_label).once.and_return(graph_spy)

        Visualizer.draw(tree, TEST_OUTPUT_FILE)
      end

      it "returns the used output file path" do
        graph_spy = instance_spy(Graphviz::Graph)
        allow(graph_spy).to receive(:attributes).and_return({})
        allow(graph_spy).to receive(:add_node).and_return(graph_spy)
        allow(Graphviz::Graph).to receive(:new).and_return(graph_spy)

        tree = RedBlackTree.new
        tree.insert(Node.new(0))
        output_file_path = "output_file.pdf"

        expect(Graphviz).to receive(:output).with(graph_spy, { path: output_file_path }).once

        path_returned = Visualizer.draw(tree, output_file_path)

        expect(path_returned).to be(output_file_path)
      end

      it "uses a default path when none is given" do
        graph_spy = instance_spy(Graphviz::Graph)
        allow(graph_spy).to receive(:attributes).and_return({})
        allow(graph_spy).to receive(:add_node).and_return(graph_spy)
        allow(Graphviz::Graph).to receive(:new).and_return(graph_spy)

        tree = RedBlackTree.new
        tree.insert(Node.new(0))

        expect(Graphviz).to receive(:output).with(graph_spy, { path: Visualizer::OUTPUT_FILE }).once

        path_returned = Visualizer.draw(tree)

        expect(path_returned).to be(Visualizer::OUTPUT_FILE)
      end
    end
  end
end
