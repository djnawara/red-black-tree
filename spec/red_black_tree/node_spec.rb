require "red_black_tree/node"

class RedBlackTree
  describe Node do
    describe ".new" do
      it "initializes new nodes as red" do
        new_node = Node.new(nil)

        expect(new_node).to be_red
      end

      it "sets the nodes key" do
        new_node = Node.new(15)

        expect(new_node.key).to be(15)
      end
    end

    describe "#red!" do
      it "sets the color of a node to red" do
        root = Node.new(nil)
        node = Node.new(nil)
        root.left_child = node
        node.parent = root
        node.instance_variable_set(:@color, Node::BLACK)

        node.red!

        expect(node).to be_red
      end

      it "silently fails to color a root node" do
        root = Node.new(nil)
        root.instance_variable_set(:@color, Node::BLACK)

        root.red!

        expect(root).not_to be_red
      end
    end

    specify "#black! sets the color of a node to black" do
      node = Node.new(nil)
      node.instance_variable_set(:@color, Node::RED)

      node.black!

      expect(node).to be_black
    end

    describe "#red?" do
      it "is true when the node's color is set to red" do
        node = Node.new(nil)
        node.instance_variable_set(:@color, Node::RED)

        expect(node).to be_red
      end

      it "is false when the node's color is black" do
        node = Node.new(nil)
        node.instance_variable_set(:@color, Node::BLACK)

        expect(node).not_to be_red
      end
    end

    describe "#black?" do
      it "is true when the node's color is set to black" do
        node = Node.new(nil)
        node.instance_variable_set(:@color, Node::BLACK)

        expect(node).to be_black
      end

      it "is false when the node's color is red" do
        node = Node.new(nil)
        node.instance_variable_set(:@color, Node::RED)

        expect(node).not_to be_black
      end
    end

    describe "#>" do
      it "is true when the right side node has a smaller key" do
        node = Node.new(10)
        other_node = Node.new(0)

        expect(node).to be > other_node
      end

      it "is false when the right side node has a larger key" do
        node = Node.new(0)
        other_node = Node.new(10)

        expect(node).not_to be > other_node
      end
    end

    describe "#<" do
      it "is true when the right side node has a larger key" do
        node = Node.new(0)
        other_node = Node.new(10)

        expect(node).to be < other_node
      end

      it "is false when the right side node has a smaller key" do
        node = Node.new(10)
        other_node = Node.new(0)

        expect(node).not_to be < other_node
      end
    end

    describe "#has_left_child?" do
      it "is true when the node links to another node with its left child pointer" do
        parent = Node.new(nil)
        child_node = Node.new(nil)

        parent.left_child = child_node

        expect(parent).to have_left_child
      end

      it "is false when the node does not link to a node with its left child pointer" do
        parent = Node.new(nil)
        child_node = Node.new(nil)

        parent.left_child = nil

        expect(parent).not_to have_left_child
      end
    end

    describe "#has_right_child?" do
      it "is true when the node links to another node with a smaller key" do
        parent = Node.new(nil)
        child_node = Node.new(nil)

        parent.right_child = child_node

        expect(parent).to have_right_child
      end

      it "is false when the node does not link to a node with a smaller key" do
        parent = Node.new(nil)
        child_node = Node.new(nil)

        parent.right_child = nil

        expect(parent).not_to have_right_child
      end
    end

    describe "#is_left_child?" do
      it "is true if the node is the left child of its parent" do
        parent = Node.new(nil)
        child_node = Node.new(nil)

        parent.left_child = child_node
        child_node.parent = parent

        expect(child_node.is_left_child?).to be(true)
      end

      it "is false if the node is the right child of its parent" do
        parent = Node.new(nil)
        child_node = Node.new(nil)

        parent.right_child = child_node

        expect(child_node.is_left_child?).to be(false)
      end

      it "is false if the node is root" do
        root = Node.new(nil)

        expect(root.is_left_child?).to be(false)
      end
    end

    describe "#is_right_child?" do
      it "is true if the node is the right child of its parent" do
        parent = Node.new(nil)
        child_node = Node.new(nil)

        parent.right_child = child_node
        child_node.parent = parent

        expect(child_node.is_right_child?).to be(true)
      end

      it "is false if the node is the left child of its parent" do
        parent = Node.new(nil)
        child_node = Node.new(nil)

        parent.left_child = child_node

        expect(child_node.is_right_child?).to be(false)
      end

      it "is false if the node is root" do
        root = Node.new(nil)

        expect(root.is_right_child?).to be(false)
      end
    end

    describe "#root?" do
      it "is true if the node does not have a parent" do
        parent = Node.new(nil)

        expect(parent).to be_root
      end

      it "is false if the node has a parent" do
        parent = Node.new(nil)
        child_node = Node.new(nil)
        parent.left_child = child_node
        child_node.parent = parent

        expect(child_node).not_to be_root
      end
    end

    describe "#grandparent" do
      it "returns the node's parent's parent" do
        grandparent = Node.new(nil)
        parent = Node.new(nil)
        child = Node.new(nil)
        grandparent.left_child = parent
        parent.parent = grandparent
        parent.left_child = child
        child.parent = parent

        expect(child.grandparent).to be_node(grandparent)
      end

      it "returns nil when the node has no grandparent (children of root)" do
        root = Node.new(nil)
        child = Node.new(nil)
        root.left_child = child

        expect(child.grandparent).to be_nil
      end

      it "returns nil for the root node" do
        root = Node.new(nil)

        expect(root).to be_root
        expect(root.grandparent).to be_nil
      end
    end

    describe "#sibling" do
      it "returns the other child of a node's parent" do
        parent = Node.new(nil)
        left_child = Node.new(nil)
        right_child = Node.new(nil)
        parent.left_child = left_child
        parent.right_child = right_child
        left_child.parent = parent
        right_child.parent = parent

        expect(left_child.sibling).to be_node(right_child)
        expect(right_child.sibling).to be_node(left_child)
      end

      it "returns nil if the node's parent has only one child" do
        parent = Node.new(nil)
        child = Node.new(nil)
        parent.left_child = child

        expect(child.sibling).to be_nil
      end

      it "returns nil if the node does not have a parent (root)" do
        root = Node.new(nil)

        expect(root.sibling).to be_nil
      end
    end

    describe "#uncle" do
      it "returns the parents sibling" do
        grandparent = Node.new(nil)
        parent = Node.new(nil)
        uncle = Node.new(nil)
        child = Node.new(nil)

        grandparent.left_child = parent
        grandparent.right_child = uncle
        uncle.parent = grandparent
        parent.parent = grandparent
        parent.left_child = child
        child.parent = parent

        expect(child.uncle).to be_node(uncle)
      end

      it "returns nil for nodes without a parent (root)" do
        root = Node.new(nil)

        expect(root.uncle).not_to be
      end

      it "returns nil if the parent node has only one child" do
        grandparent = Node.new(nil)
        parent = Node.new(nil)
        child = Node.new(nil)

        grandparent.left_child = parent
        parent.left_child = child

        expect(child.uncle).not_to be
      end
    end

    specify "#get_label includes the node's key" do
      node = Node.new(19)

      expect(node.get_label).to eq("(#{node.key})")
    end

    describe "#to_s" do
      it "outputs the node's key, parent key, and the keys of its children" do
        node = Node.new(50)
        parent = Node.new(75)
        left_child = Node.new(25)
        right_child = Node.new(65)
        node.parent = parent
        node.left_child = left_child
        node.right_child = right_child

        expect(node.to_s).to include("key=50")
        expect(node.to_s).to include("parent=75")
        expect(node.to_s).to include("left_child=25")
        expect(node.to_s).to include("right_child=65")
      end

      it "shows the parent and children as nil when they don't exist" do
        node = Node.new(50)

        expect(node.to_s).to include("key=50")
        expect(node.to_s).to include("parent=nil")
        expect(node.to_s).to include("left_child=nil")
        expect(node.to_s).to include("right_child=nil")
      end
    end
  end
end
