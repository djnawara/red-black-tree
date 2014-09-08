require "red_black_tree"
require "red_black_tree/node"

class RedBlackTree
  module Builder
    class << self
      def random_tree(node_count = 10)
        tree = RedBlackTree.new
        node_count.times { tree.insert(random_node) }

        tree
      end

      def random_node(key_minimum = 1, key_maximum = 10_000)
        key = rand(key_minimum..key_maximum)
        Node.new(key)
      end
    end
  end
end
