defmodule LinkNode do
  defstruct value: nil,
            next: nil

  @type t :: %__MODULE__{
          value: integer(),
          next: __MODULE__.t()
        }

  def new(value) when is_integer(value) do
    struct!(__MODULE__, value: value, next: nil)
  end

  def new(value, %__MODULE__{} = next) do
    struct!(__MODULE__, value: value, next: next)
  end
end

defmodule LinkedList do
  defstruct head: nil,
            size: 0

  @type t :: %__MODULE__{
          head: LinkNode.t(),
          size: integer()
        }

  @doc """
  Creates a new linked list

  #Example
      iex> LinkedList.new()\
      |> LinkedList.to_list()
      []
  """
  def new() do
    struct!(__MODULE__)
  end

  @doc """
  Creates a linked list from a list

  #Example
      iex>LinkedList.from_list([1,2,3,4]) |> LinkedList.to_list()
      [1,2,3,4]

      iex>LinkedList.from_list([2,5,8, 1]) |> LinkedList.to_list()
      [2,5,8,1]
  """
  def from_list(list) do
    Enum.reduce(list, new(), fn e, l ->
      add(l, e)
    end)
  end

  @doc """
  Add a new node to end of linked list

  #Example
      iex> LinkedList.new()\
      |> LinkedList.add(1)\
      |> LinkedList.to_list()
      [1]
      iex> LinkedList.new()\
      |> LinkedList.add(1)\
      |> LinkedList.add(2)\
      |> LinkedList.to_list()
      [1, 2]
  """
  def add(%__MODULE__{head: nil}, value) do
    head = LinkNode.new(value)
    %__MODULE__{head: head, size: 1}
  end

  # add 2, {head: {1, nil}} -> {head: {1, {2, nil}}}
  def add(%__MODULE__{head: head, size: size} = l, value) do
    new_head = add_with_node(head, value)
    # IO.inspect(new_head, label: "Head node")
    %__MODULE__{l | head: new_head, size: size + 1}
  end

  @doc """
  Deletes a node at given index from linked list

  #Example
      iex> l = LinkedList.from_list([1,2,3,4,5])       
      iex> {_, l} = LinkedList.delete_at(l,0)                
      iex> LinkedList.to_list(l)
      [2,3,4,5]

      iex> l = LinkedList.from_list([1,2,3,4,5])        
      iex> {_, l} = LinkedList.delete_at(l,1)                
      iex> LinkedList.to_list(l)
      [1,3,4,5]

      iex> l = LinkedList.from_list([1,2,3,4,5])        
      iex> {_, l} = LinkedList.delete_at(l,2)                
      iex> LinkedList.to_list(l)
      [1,2,4,5]

      iex> l = LinkedList.from_list([1,2,3,4,5])        
      iex> {_, l} = LinkedList.delete_at(l,3)                
      iex> LinkedList.to_list(l)
      [1,2,3,5]
  """
  def delete_at(%__MODULE__{head: nil} = l, _) do
    {nil, l}
  end

  def delete_at(%__MODULE__{head: %LinkNode{next: next} = head, size: size} = l, index)
      when index <= 0 do
    {head, %{l | head: next, size: size - 1}}
  end

  def delete_at(%__MODULE__{head: head, size: size} = l, index) do
    # {head, %{l | head: next, size: (size - 1)}}
    {node, new_head} = delete_with_node_at(head, index - 1)
    {node, %{l | head: new_head, size: size - 1}}
  end

  @doc """
  Insert value at the given index in the list

  #Example
      iex> l = LinkedList.from_list([1,2,3,4,5])
      iex> l = LinkedList.insert_at(l, 0, 6)
      iex> LinkedList.to_list(l)
      [6,1,2,3,4,5]

      iex> l = LinkedList.from_list([1,2,3,4,5])
      iex> l = LinkedList.insert_at(l, 2, 6)
      iex> LinkedList.to_list(l)
      [1,2,6,3,4,5]

      iex> l = LinkedList.new()
      iex> l = LinkedList.insert_at(l, 2, 6)
      iex> LinkedList.to_list(l)
      [6]
  """
  def insert_at(%__MODULE__{head: nil} = l, _index, value) do
    add(l, value)
  end

  def insert_at(%__MODULE__{head: head, size: size} = l, index, value) when index <= 0 do
    new_head = LinkNode.new(value, head)
    %__MODULE__{l | head: new_head, size: size + 1}
  end

  def insert_at(%__MODULE__{head: head, size: size} = l, index, value) do
    new_head = insert_with_node_at(head, index - 1, value)
    %__MODULE__{l | head: new_head, size: size + 1}
  end

  @doc """
  Reverse elements in linked list

  #Example
      iex> l = LinkedList.from_list([1])
      iex> l = LinkedList.reverse(l)
      iex> LinkedList.to_list(l)
      [1]

      iex> l = LinkedList.from_list([1,2])
      iex> l = LinkedList.reverse(l)
      iex> LinkedList.to_list(l)
      [2,1]

      iex> l = LinkedList.from_list([1,2,3,4])
      iex> l = LinkedList.reverse(l)
      iex> LinkedList.to_list(l)
      [4,3,2,1]
  """
  def reverse(%__MODULE__{head: nil} = l) do
    l
  end

  def reverse(%__MODULE__{head: head} = l) do
    %{l | head: reverse_from_node(head, nil)}
  end

  def to_list(%__MODULE__{head: head}) do
    to_list(head, [])
  end

  def print_all(%__MODULE__{} = l) do
    IO.inspect(to_list(l))
  end

  # PRIVATE FUNCTIONS

  # [1, 2, 3] -> 
  # reverse_from_node(1->2->3)
  # reverse_from_node(2->3)
  # 
  defp reverse_from_node(nil, node_next) do
    node_next
  end

  defp reverse_from_node(%{next: next} = node, node_next) do
    reverse_from_node(next, %{node | next: node_next})
  end

  defp delete_with_node_at(%{next: next} = node, 0) do
    {next, %{node | next: next.next}}
  end

  defp delete_with_node_at(%{} = node, index) when index < 0 do
    {nil, node}
  end

  defp delete_with_node_at(%{next: next} = node, index) do
    {deleted_node, new_next} = delete_with_node_at(next, index - 1)
    {deleted_node, %{node | next: new_next}}
  end

  defp insert_with_node_at(%LinkNode{next: nil} = node, _index, value) do
    next = LinkNode.new(value)
    %LinkNode{node | next: next}
  end

  defp insert_with_node_at(%LinkNode{next: next} = node, 0 = _index, value) do
    new_next = LinkNode.new(value, next)
    %LinkNode{node | next: new_next}
  end

  defp insert_with_node_at(%LinkNode{next: next} = node, index, value) do
    %LinkNode{node | next: insert_with_node_at(next, index - 1, value)}
  end

  defp add_with_node(%LinkNode{next: nil} = node, value) do
    next = LinkNode.new(value)
    %LinkNode{node | next: next}
  end

  defp add_with_node(%LinkNode{next: next} = node, value) do
    %LinkNode{node | next: add_with_node(next, value)}
  end

  defp to_list(nil, acc) do
    :lists.reverse(acc)
  end

  defp to_list(%LinkNode{value: value, next: next}, acc) do
    to_list(next, [value | acc])
  end
end
