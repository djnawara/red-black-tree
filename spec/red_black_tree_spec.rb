require "red_black_tree"
require "red_black_tree/node"

describe RedBlackTree do
  specify "#size provides a count of all nodes in the tree" do
    root = RedBlackTree::Node.new(10)
    left_child_node = RedBlackTree::Node.new(5)
    right_child_node = RedBlackTree::Node.new(15)
    grandchild_node = RedBlackTree::Node.new(0)

    tree = RedBlackTree.new
    tree.insert(root)
    tree.insert(left_child_node)
    tree.insert(right_child_node)
    tree.insert(grandchild_node)

    expect(tree.size).to be(4)
  end

  describe "#insert" do
    it "correctly shifts children to a new parent when rotating left" do
      root = RedBlackTree::Node.new(500)
      right_subtree_parent = RedBlackTree::Node.new(750)
      node_to_get_rotated_down = RedBlackTree::Node.new(250)
      small_node = RedBlackTree::Node.new(100)
      node_to_get_rotated_up = RedBlackTree::Node.new(300)
      node_to_trigger_recolor_of_node_to_rotate_down = RedBlackTree::Node.new(50)
      node_to_have_its_parent_changed = RedBlackTree::Node.new(275)
      right_child_of_node_to_rotate_up = RedBlackTree::Node.new(325)
      node_to_trigger_rotation_and_shifting_parents = RedBlackTree::Node.new(350)

      tree = RedBlackTree.new
      tree.insert(root)
      tree.insert(right_subtree_parent)
      tree.insert(node_to_get_rotated_down)
      tree.insert(small_node)
      tree.insert(node_to_get_rotated_up)
      tree.insert(node_to_trigger_recolor_of_node_to_rotate_down)
      tree.insert(node_to_have_its_parent_changed)
      tree.insert(right_child_of_node_to_rotate_up)
      tree.insert(node_to_trigger_rotation_and_shifting_parents )

      expect(node_to_have_its_parent_changed.parent).to be_node(node_to_get_rotated_down)
      expect(node_to_get_rotated_down.right_child).to be_node(node_to_have_its_parent_changed)
    end

    it "correctly shifts children to a new parent when rotating right" do
      root = RedBlackTree::Node.new(500)
      left_subtree_parent = RedBlackTree::Node.new(250)
      node_to_get_rotated_down = RedBlackTree::Node.new(800)
      large_node = RedBlackTree::Node.new(1_000)
      node_to_get_rotated_up = RedBlackTree::Node.new(750)
      node_to_trigger_recolor_of_node_to_rotate_down = RedBlackTree::Node.new(1_500)
      node_to_have_its_parent_changed = RedBlackTree::Node.new(775)
      left_child_of_node_to_rotate_up = RedBlackTree::Node.new(600)
      node_to_trigger_rotation_and_shifting_parents = RedBlackTree::Node.new(780)

      tree = RedBlackTree.new
      tree.insert(root)
      tree.insert(left_subtree_parent)
      tree.insert(node_to_get_rotated_down)
      tree.insert(large_node)
      tree.insert(node_to_get_rotated_up)
      tree.insert(node_to_trigger_recolor_of_node_to_rotate_down)
      tree.insert(node_to_have_its_parent_changed)
      tree.insert(left_child_of_node_to_rotate_up)
      tree.insert(node_to_trigger_rotation_and_shifting_parents )

      expect(node_to_have_its_parent_changed.parent).to be_node(node_to_get_rotated_down)
      expect(node_to_get_rotated_down.left_child).to be_node(node_to_have_its_parent_changed)
    end

    it "inserts the first node as root" do
      root = RedBlackTree::Node.new(10)

      tree = RedBlackTree.new
      tree.insert(root)

      expect(tree.root).to be_node(root)
    end

    it "inserts a node with a smaller index on the left" do
      root = RedBlackTree::Node.new(10)
      smaller_node = RedBlackTree::Node.new(5)

      tree = RedBlackTree.new
      tree.insert(root)
      tree.insert(smaller_node)

      expect(root.right_child).not_to be
      expect(root.left_child).to be_node(smaller_node)
    end

    it "inserts a node with a larger index on the right" do
      root = RedBlackTree::Node.new(10)
      larger_node = RedBlackTree::Node.new(15)

      tree = RedBlackTree.new
      tree.insert(root)
      tree.insert(larger_node)

      expect(root.left_child).not_to be
      expect(root.right_child).to be_node(larger_node)
    end

    it "balances adding a smaller and then slightly less small node to a new tree (zig zag)" do
      root = RedBlackTree::Node.new(100)
      smallest_node = RedBlackTree::Node.new(0)
      small_node = RedBlackTree::Node.new(50)

      tree = RedBlackTree.new
      tree.insert(root)
      tree.insert(smallest_node)
      tree.insert(small_node)

      expect(tree.root).to be_node(small_node)
      expect(tree.root.right_child).to be_node(root)
      expect(tree.root.left_child).to be_node(smallest_node)
      expect(tree.root).to be_black
      expect(tree.root.left_child).to be_red
      expect(tree.root.right_child).to be_red
    end

    it "balances adding a larger and then slightly less large node to a new tree (zig zag)" do
      root = RedBlackTree::Node.new(0)
      large_node = RedBlackTree::Node.new(50)
      largest_node = RedBlackTree::Node.new(100)

      tree = RedBlackTree.new
      tree.insert(root)
      tree.insert(largest_node)
      tree.insert(large_node)

      expect(tree.root).to be_node(large_node)
      expect(tree.root.right_child).to be_node(largest_node)
      expect(tree.root.left_child).to be_node(root)
      expect(tree.root).to be_black
      expect(tree.root.left_child).to be_red
      expect(tree.root.right_child).to be_red
    end

    context "when encountering a double-red collision on insert" do
      context "when the parent has a sibling (the new node's uncle) and that sibling is red" do
        it "recolors the parent and uncle black" do
          root = RedBlackTree::Node.new(10)
          parent = RedBlackTree::Node.new(5)
          uncle = RedBlackTree::Node.new(15)
          child = RedBlackTree::Node.new(0)

          tree = RedBlackTree.new
          tree.insert(root)
          tree.insert(parent)
          tree.insert(uncle)
          tree.insert(child)

          expect(tree.root).to be_black
          expect(parent).to be_black
          expect(uncle).to be_black
          expect(child).to be_red
        end

        it "recolors the grandparent red" do
          root = RedBlackTree::Node.new(50)
          greatuncle = RedBlackTree::Node.new(75)
          grandparent = RedBlackTree::Node.new(25)
          parent = RedBlackTree::Node.new(15)
          uncle = RedBlackTree::Node.new(35)
          child = RedBlackTree::Node.new(5)

          tree = RedBlackTree.new
          tree.insert(root)
          tree.insert(grandparent)
          tree.insert(greatuncle)
          tree.insert(parent)
          tree.insert(uncle)
          tree.insert(child)

          expect(tree.root).to be_black
          expect(grandparent).to be_red
          expect(greatuncle).to be_black
          expect(parent).to be_black
          expect(uncle).to be_black
          expect(child).to be_red
        end
      end

      context "when the parent has a sibling (the new node's uncle) and that sibling is black" do
        context "when the parent is the left child of the grandparent" do
          it "rebalances the tree by bubbling up a double-red collision and rotating the great grandparent to become root" do
            root = RedBlackTree::Node.new(50)
            greatgreatuncle = RedBlackTree::Node.new(75)
            greatgrandparent = RedBlackTree::Node.new(25)
            grandparent = RedBlackTree::Node.new(15)
            greatuncle = RedBlackTree::Node.new(35)
            uncle = RedBlackTree::Node.new(20)
            parent = RedBlackTree::Node.new(5)
            child = RedBlackTree::Node.new(0)

            tree = RedBlackTree.new
            tree.insert(root)
            tree.insert(greatgreatuncle)
            tree.insert(greatgrandparent)
            tree.insert(grandparent)
            tree.insert(greatuncle)
            tree.insert(uncle)
            tree.insert(parent)
            tree.insert(child)

            expect(tree.root).to be_node(greatgrandparent)
            expect(greatgrandparent.right_child).to be_node(root)
            expect(root.left_child).to be_node(greatuncle)
            expect(root.right_child).to be_node(greatgreatuncle)
            expect(grandparent.right_child).to be_node(uncle)
            expect(grandparent.left_child).to be_node(parent)
            expect(parent.left_child).to be_node(child)

            expect(tree.root).to be_black
            expect(tree.root.left_child).to be_red
            expect(tree.root.right_child).to be_red
          end
        end

        context "when the parent is the right child of the grandparent" do
          it "rebalances the tree by bubbling up a double-red collision and rotating the great grandparent to become root" do
            root = RedBlackTree::Node.new(50)
            greatgreatuncle = RedBlackTree::Node.new(25)
            greatgrandparent = RedBlackTree::Node.new(75)
            grandparent = RedBlackTree::Node.new(100)
            greatuncle = RedBlackTree::Node.new(65)
            uncle = RedBlackTree::Node.new(85)
            parent = RedBlackTree::Node.new(125)
            child = RedBlackTree::Node.new(150)

            tree = RedBlackTree.new
            tree.insert(root)
            tree.insert(greatgreatuncle)
            tree.insert(greatgrandparent)
            tree.insert(grandparent)
            tree.insert(greatuncle)
            tree.insert(uncle)
            tree.insert(parent)
            tree.insert(child)

            expect(tree.root).to be_node(greatgrandparent)
            expect(greatgrandparent.left_child).to be_node(root)
            expect(root.right_child).to be_node(greatuncle)
            expect(root.left_child).to be_node(greatgreatuncle)
            expect(grandparent.left_child).to be_node(uncle)
            expect(grandparent.right_child).to be_node(parent)
            expect(parent.right_child).to be_node(child)

            expect(tree.root).to be_black
            expect(tree.root.left_child).to be_red
            expect(tree.root.right_child).to be_red
          end
        end
      end

      context "when the parent has no sibling and is the left child" do
        it "promotes the parent to replace the grandparent and demotes the grandparent to be a child of the parent (right rotate)" do
          root = RedBlackTree::Node.new(50)
          greatuncle = RedBlackTree::Node.new(75)
          grandparent = RedBlackTree::Node.new(25)
          parent = RedBlackTree::Node.new(15)
          uncle = RedBlackTree::Node.new(35)
          child = RedBlackTree::Node.new(5)
          new_node = RedBlackTree::Node.new(0)

          tree = RedBlackTree.new
          tree.insert(root)
          tree.insert(grandparent)
          tree.insert(greatuncle)
          tree.insert(parent)
          tree.insert(uncle)
          tree.insert(child)

          tree.insert(new_node)

          expect(grandparent.left_child).to be_node(child)
          expect(child.right_child).to be_node(parent)
          expect(child.left_child).to be_node(new_node)
          expect(child).to be_black
          expect(parent).to be_red
        end

        it "replaces the grandparent as root with the parent" do
          grandparent = RedBlackTree::Node.new(10)
          parent = RedBlackTree::Node.new(5)
          child = RedBlackTree::Node.new(0)

          tree = RedBlackTree.new
          tree.insert(grandparent)
          tree.insert(parent)
          tree.insert(child)

          expect(tree.root).to be_node(parent)
          expect(tree.root.right_child).to be_node(grandparent)
          expect(tree.root.left_child).to be_node(child)
          expect(tree.root).to be_black
          expect(tree.root.right_child).to be_red
          expect(tree.root.left_child).to be_red
        end
      end

      context "when the parent has no sibling and is the right child" do
        it "promotes the parent to replace the grandparent and demotes the grandparent to be a child of the parent (left rotate)" do
          root = RedBlackTree::Node.new(50)
          greatuncle = RedBlackTree::Node.new(25)
          grandparent = RedBlackTree::Node.new(75)
          parent = RedBlackTree::Node.new(100)
          uncle = RedBlackTree::Node.new(60)
          child = RedBlackTree::Node.new(125)
          new_node = RedBlackTree::Node.new(150)

          tree = RedBlackTree.new
          tree.insert(root)
          tree.insert(grandparent)
          tree.insert(greatuncle)
          tree.insert(parent)
          tree.insert(uncle)
          tree.insert(child)

          tree.insert(new_node)

          expect(grandparent.right_child).to be_node(child)
          expect(child.left_child).to be_node(parent)
          expect(child.right_child).to be_node(new_node)
          expect(child).to be_black
          expect(parent).to be_red
        end

        it "replaces the grandparent as root with the parent" do
          grandparent = RedBlackTree::Node.new(0)
          parent = RedBlackTree::Node.new(5)
          child = RedBlackTree::Node.new(10)

          tree = RedBlackTree.new
          tree.insert(grandparent)
          tree.insert(parent)
          tree.insert(child)

          expect(tree.root).to be_node(parent)
          expect(tree.root.right_child).to be_node(child)
          expect(tree.root.left_child).to be_node(grandparent)
          expect(tree.root).to be_black
          expect(tree.root.right_child).to be_red
          expect(tree.root.left_child).to be_red
        end
      end
    end
  end
end
