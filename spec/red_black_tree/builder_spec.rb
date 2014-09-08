require "red_black_tree/builder"

class RedBlackTree
  describe Builder do
    specify ".random_tree makes a random tree with a size equal to the supplied number" do
      tree = Builder.random_tree(20)
      expect(tree.size).to be(20)
    end

    specify ".random_node makes a new random node with a key within the specified range" do
      not_so_random_node = Builder.random_node(99, 99)
      more_random_node = Builder.random_node(1, 10)

      expect(not_so_random_node.key).to be(99)
      expect(more_random_node.key).to be >= 1
      expect(more_random_node.key).to be <= 10
    end
  end
end
