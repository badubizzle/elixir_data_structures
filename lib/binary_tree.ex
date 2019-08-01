defmodule BinaryNode do
  @enforce_keys [:value]
  defstruct value: nil,
            right: nil,
            left: nil

  @type t :: %__MODULE__{
          value: integer(),
          right: BinaryNode.t(),
          left: BinaryNode.t()
        }

  @doc """
  Create new Node

  #Example
      iex> BinaryNode.new(1)
      %BinaryNode{value: 1}

      iex> BinaryNode.new(2)
      %BinaryNode{value: 2}
  """
  def new(value, left \\ nil, right \\ nil) do
    struct!(__MODULE__, value: value, left: left, right: right)
  end

  def left(%__MODULE__{left: left}) do
    left
  end

  def right(%__MODULE__{right: right}) do
    right
  end

  @doc """
  Returns true if node is a leaf node

  #Example
      iex> node = BinaryNode.new(2, BinaryNode.new(1))
      iex> BinaryNode.is_leaf(node)
      false

      iex> node = BinaryNode.new(1)
      iex> BinaryNode.is_leaf(node)
      true
  """
  def is_leaf(%__MODULE__{right: nil, left: nil}) do
    true
  end

  def is_leaf(%__MODULE__{}) do
    false
  end
end

defmodule BinaryTree do
  defstruct root: nil

  @type t :: %__MODULE__{
          root: BinaryNode.t()
        }

  @doc """
  Create a new binary tree

  #Example
      iex> BinaryTree.new()
      %BinaryTree{root: nil}
  """
  def new() do
    struct!(__MODULE__, root: nil)
  end

  @doc """
  Create a binary tree from list

  #Example
      iex> t = BinaryTree.from_list([4,5,3,1])
      iex> BinaryTree.in_order_list(t)
      [1,3,4,5]
  """
  def from_list(list) when is_list(list) do
    Enum.reduce(list, new(), fn e, t ->
      insert(t, e)
    end)
  end

  def insert(%__MODULE__{root: nil} = t, value) do
    %{t | root: BinaryNode.new(value)}
  end

  def insert(%__MODULE__{root: root} = t, value) do
    %{t | root: insert_with_node(root, value)}
  end

  @doc """
  Find a node with a the given value in the tree

  #Example
      iex> t = BinaryTree.from_list([4,5,3,1,2,0])
      iex> BinaryTree.find(t, 5)
      %BinaryNode{value: 5}

      iex> t = BinaryTree.from_list([4,5,3,1,2,0])
      iex> BinaryTree.find(t, 6)
      nil
  """
  def find(%__MODULE__{root: root}, value) do
    do_find(root, value)
  end

  @doc """
  Return nodes as inorder list

  #Example
      iex> t = BinaryTree.new()
      iex> t = BinaryTree.insert(t, 4)
      iex> t = BinaryTree.insert(t, 3)
      iex> t = BinaryTree.insert(t, 5)
      iex> BinaryTree.in_order_list(t)
      [3,4,5]
  """
  def in_order_list(%{root: root}) do
    do_to_list_in_order(root, [])
  end

  @doc """
  Return nodes as pre list

  #Example
      iex> t = BinaryTree.from_list([4, 3, 5])                
      iex> BinaryTree.pre_order_list(t)
      [4,3,5]
  """
  def pre_order_list(%{root: root}) do
    do_pre_order_list(root, [])
  end

  @doc """
  Return nodes as post list

  #Example
      iex> t = BinaryTree.from_list([4, 3, 5, 1, 0, 2])                
      iex> BinaryTree.post_order_list(t)
      [0,2,1,3,5,4]
  """
  def post_order_list(%{root: root}) do
    do_post_order_list(root, [])
  end

  @doc """
  Returns dfs list of nodes in tree

  #Example
      iex> t = BinaryTree.from_list([4,3,6,5,2,8])
      iex> BinaryTree.dfs_list(t)
      [4, 3, 2, 6,5,8]
  """
  def dfs_list(%{root: root}) do
    dfs([root], [])
  end

  @doc """
  Get nodes in tree as bfs list

  #Example
      iex> t = BinaryTree.from_list([4,3,5,1,2])
      iex> BinaryTree.bfs_list(t)
      [4,3,5,1,2]
  """
  def bfs_list(%{root: root}) do
    bfs([root], [])
  end

  @doc """
  Delete a node with the given value from the tree

  #Example
     
      # iex> t = BinaryTree.from_list([4,3])
      # iex> t = BinaryTree.delete(t, 3)
      # iex> BinaryTree.in_order_list(t)
      # [4]


      iex> t = BinaryTree.from_list([4,3,6,8])
      iex> t = BinaryTree.delete(t, 8)
      iex> BinaryTree.in_order_list(t)
      [3, 4, 6]

      iex> t = BinaryTree.from_list([4,3,6,8])
      iex> t = BinaryTree.delete(t, 6)
      iex> BinaryTree.in_order_list(t)
      [3, 4, 8]

      iex> t = BinaryTree.from_list([4,3,6,8])
      iex> t = BinaryTree.delete(t, 3)
      iex> BinaryTree.in_order_list(t)
      [4, 6, 8]

      iex> t = BinaryTree.from_list([4,3,6,7])
      iex> t = BinaryTree.delete(t, 4)
      iex> BinaryTree.in_order_list(t)
      [3, 6, 7]

      iex> t = BinaryTree.from_list([4,3,6,1,2,7])
      iex> t = BinaryTree.delete(t, 3)
      iex> BinaryTree.bfs_list(t)
      [4, 1, 6,2,7]
  """
  def delete(%__MODULE__{root: nil} = t, _value) do
    t
  end

  def delete(%__MODULE__{root: root} = t, value) do
    # IO.inspect(root, label: "Old root")
    new_root = find_and_delete(root, value)
    # IO.inspect(new_root, label: "New root")
    %{t | root: new_root}
  end

  # PRIVATE FUNCTIONS

  defp find_min_node(%{left: nil} = node) do
    node
  end

  defp find_min_node(%{left: left}) do
    find_min_node(left)
  end

  defp find_and_delete(node, value) do
    # IO.inspect([node, value], label: "Delet node")
    cond do
      is_nil(node) ->
        nil

      node.value > value ->
        # IO.inspect([node.left, value], label: "Look in left sub tree")
        %{node | left: find_and_delete(node.left, value)}

      node.value < value ->
        # IO.inspect([node.right, value], label: "Look in right sub tree")
        %{node | right: find_and_delete(node.right, value)}

      node.value == value ->
        cond do
          is_nil(node.left) and is_nil(node.right) ->
            # IO.inspect([node, value], label: "Case 1")
            nil

          is_nil(node.left) ->
            # IO.inspect([node, value], label: "Case 2a")
            node.right

          is_nil(node.right) ->
            # IO.inspect([node, value], label: "Case 2b")
            node.left

          true ->
            min_node = find_min_node(node.right)
            new_node = %{node | value: min_node.value}
            %{new_node | right: find_and_delete(node.right, min_node.value)}
        end
    end
  end

  defp do_find(nil, _value) do
    nil
  end

  defp do_find(%{value: v} = node, value) do
    cond do
      v == value ->
        node

      v > value ->
        do_find(node.left, value)

      true ->
        do_find(node.right, value)
    end
  end

  defp do_to_list_in_order(nil, acc) do
    acc
  end

  defp do_to_list_in_order(%{left: left, right: right} = node, acc) do
    l1 = do_to_list_in_order(left, acc)
    l2 = List.insert_at(l1, -1, node.value)
    do_to_list_in_order(right, l2)
  end

  defp do_post_order_list(nil, acc) do
    acc
  end

  defp do_post_order_list(%{left: left, right: right} = node, acc) do
    l1 = do_post_order_list(left, acc)
    l2 = do_post_order_list(right, l1)
    List.insert_at(l2, -1, node.value)
  end

  defp do_pre_order_list(nil, acc) do
    acc
  end

  defp do_pre_order_list(%{left: left, right: right} = node, acc) do
    l0 = List.insert_at(acc, -1, node.value)
    l1 = do_pre_order_list(left, l0)
    do_pre_order_list(right, l1)
  end

  defp bfs([], acc) do
    :lists.reverse(acc)
  end

  defp bfs(queue, acc) when is_list(queue) do
    n = hd(queue)
    # IO.inspect(n.value, label: "Current node")
    child_nodes =
      cond do
        is_nil(n.left) and is_nil(n.right) ->
          []

        is_nil(n.right) ->
          [n.left]

        is_nil(n.left) ->
          [n.right]

        true ->
          [n.left, n.right]
      end

    new_queue = List.flatten([tl(queue), child_nodes])
    bfs(new_queue, [n.value | acc])
  end

  defp dfs([], acc) do
    :lists.reverse(acc)
  end

  defp dfs(stack, acc) do
    n = hd(stack)

    new_stack =
      cond do
        is_nil(n.left) and is_nil(n.right) ->
          tl(stack)

        is_nil(n.right) ->
          [n.left | tl(stack)]

        is_nil(n.left) ->
          [n.right | tl(stack)]

        true ->
          [n.left | [n.right | tl(stack)]]
      end

    dfs(new_stack, [n.value | acc])
  end

  defp insert_with_node(%{value: node_value} = node, value)
       when node_value > value do
    if is_nil(node.left) do
      %{node | left: BinaryNode.new(value)}
    else
      %{node | left: insert_with_node(node.left, value)}
    end
  end

  defp insert_with_node(%{value: node_value} = node, value)
       when node_value <= value do
    if is_nil(node.right) do
      %{node | right: BinaryNode.new(value)}
    else
      %{node | right: insert_with_node(node.right, value)}
    end
  end
end
