class RedBlackTree
  attr_reader :root

  def insert(new_node, prospective_parent = @root)
    if @root.nil?
      @root = new_node
      @root.black!
      return
    end

    binary_search_tree_insert(new_node, prospective_parent)
    red_black_rebalance(new_node)
  end

  def size(node = @root)
    return 0 if node.nil?

    size = 1
    size += size(node.left_child)
    size += size(node.right_child)
  end

  private

  def binary_search_tree_insert(new_node, prospective_parent)
    if should_go_left?(prospective_parent, new_node)
      if prospective_parent.has_left_child?
        binary_search_tree_insert(new_node, prospective_parent.left_child)
      else
        prospective_parent.left_child = new_node
        new_node.parent = prospective_parent
      end
      return
    end

    if should_go_right?(prospective_parent, new_node)
      if prospective_parent.has_right_child?
        binary_search_tree_insert(new_node, prospective_parent.right_child)
      else
        prospective_parent.right_child = new_node
        new_node.parent = prospective_parent
      end
    end
  end

  def red_black_rebalance(node)
    return if node.root?
    recolor(node)
    straighten(node)
    balance(node)
  end

  def is_in_red_violation?(node)
    node.red? && node.parent.red?
  end

  def has_red_parent_and_uncle?(node)
    is_in_red_violation?(node) && node.uncle && node.uncle.red?
  end

  def recolor(node)
    return unless has_red_parent_and_uncle?(node)

    node.parent.black!
    node.uncle.black!
    node.grandparent.red!

    red_black_rebalance(node.grandparent)
  end

  def straighten(node)
    return unless is_in_red_violation?(node)

    parent = node.parent

    if node.is_right_child? && parent.is_left_child?
      left_rotate(parent)
      red_black_rebalance(parent)
      return
    end

    if node.is_left_child? && parent.is_right_child?
      right_rotate(parent)
      red_black_rebalance(parent)
    end
  end

  def balance(node)
    return unless is_in_red_violation?(node)

    parent = node.parent
    grandparent = parent.parent

    if node.is_left_child? && parent.is_left_child?
      right_rotate(grandparent)
      grandparent.red!
      parent.black!
    end

    if node.is_right_child? && parent.is_right_child?
      left_rotate(grandparent)
      grandparent.red!
      parent.black!
    end

    @root = parent if parent.root?
  end

  def left_rotate(node)
    child = node.right_child
    parent = node.parent

    parent.left_child = child if parent && node.is_left_child?
    parent.right_child = child if parent && node.is_right_child?
    child.parent = parent

    node.right_child = child.left_child
    node.right_child.parent = node if node.right_child

    child.left_child = node
    node.parent = child
  end

  def right_rotate(node)
    child = node.left_child
    parent = node.parent

    parent.right_child = child if parent && node.is_right_child?
    parent.left_child = child if parent && node.is_left_child?
    child.parent = parent

    node.left_child = child.right_child
    node.left_child.parent = node if node.left_child

    child.right_child = node
    node.parent = child
  end

  def should_go_left?(existing_node, new_node)
    existing_node > new_node
  end

  def should_go_right?(existing_node, new_node)
    new_node > existing_node
  end
end
