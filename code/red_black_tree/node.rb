class RedBlackTree
  class Node
    BLACK = :black
    RED = :red
    COLORS = [RED, BLACK].freeze

    attr_reader :key, :color
    attr_accessor :left_child, :right_child, :parent

    def initialize(key)
      @key = key
      @color = RED
    end

    def >(other_node)
      key > other_node.key
    end

    def <(other_node)
      key < other_node.key
    end

    def has_left_child?
      !!left_child
    end

    def has_right_child?
      !!right_child
    end

    def is_left_child?
      return false if root?
      parent.left_child == self
    end

    def is_right_child?
      return false if root?
      parent.right_child == self
    end

    def root?
      parent.nil?
    end

    def red?
      @color == RED
    end

    def red!
      return if root?
      @color = RED
    end

    def black?
      @color == BLACK
    end

    def black!
      @color = BLACK
    end

    def grandparent
      return if root?
      parent.parent
    end

    def sibling
      return if root?
      return parent.left_child if is_right_child?
      parent.right_child
    end

    def uncle
      return if root?
      parent.sibling
    end

    def detach!
      @parent.left_child = nil if is_left_child?
      @parent.right_child = nil if is_right_child?
      @parent = nil
    end

    def get_label
      "(#{key})"
    end

    def to_s
      parent_key = parent.nil? ? "nil" : parent.key
      left_child_key = left_child.nil? ? "nil" : left_child.key
      right_child_key = right_child.nil? ? "nil" : right_child.key

      "<#{self.class} key=#{key} parent=#{parent_key} left_child=#{left_child_key} right_child=#{right_child_key} />"
    end
  end
end
