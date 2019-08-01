defmodule ListUtils do
  @doc """

  #Example
      iex> ListUtils.swap([1,2,3,4,5], 0, 4)
      [5,2,3,4,1]
  """
  def swap(l, i, j) do
    swap(l, Enum.count(l), i, j)
  end

  defp swap(l, _n, i, i) do
    l
  end

  defp swap(l, n, i, j) when i < n and j < n do
    temp = Enum.at(l, i)

    l
    |> List.replace_at(i, Enum.at(l, j))
    |> List.replace_at(j, temp)
  end

  def shift(l, 0, _) do
    l
  end

  def shift(l, index, t) when t in [:max, :min] do
    parent_index = div(index - 1, 2)

    new_l =
      case t do
        :max ->
          if Enum.at(l, parent_index) < Enum.at(l, index) do
            ListUtils.swap(l, parent_index, index)
          else
            l
          end

        :min ->
          if Enum.at(l, parent_index) > Enum.at(l, index) do
            ListUtils.swap(l, parent_index, index)
          else
            l
          end
      end

    shift(new_l, parent_index, t)
  end

  def shift_max(l, index) do
    shift(l, index, :max)
  end

  def shift_min(l, index) do
    shift(l, index, :min)
  end

  def max_heapify(l, index) do
    heapify(l, index, :max)
  end

  def min_heapify(l, index) do
    heapify(l, index, :min)
  end

  @doc """
  #Example

      iex> ListUtils.heapify([1], 0, :max)
      [1]
      
      iex> ListUtils.heapify([6,4,5], 0, :max)
      [6,4,5]
      
  """
  def heapify(l, index, t) when t in [:max, :min] do
    left_index = index * 2 + 1
    right_index = index * 2 + 2
    last_index = Enum.count(l) - 1

    swap_index =
      case t do
        :max ->
          max_index =
            if left_index <= last_index and Enum.at(l, left_index) > Enum.at(l, index) do
              left_index
            else
              index
            end

          if right_index <= last_index and Enum.at(l, right_index) > Enum.at(l, max_index) do
            right_index
          else
            max_index
          end

        :min ->
          min_index =
            if left_index <= last_index and Enum.at(l, left_index) < Enum.at(l, index) do
              left_index
            else
              index
            end

          if right_index <= last_index and Enum.at(l, right_index) < Enum.at(l, min_index) do
            right_index
          else
            min_index
          end
      end

    if swap_index != index do
      heapify(ListUtils.swap(l, index, swap_index), swap_index, t)
    else
      l
    end
  end
end

defmodule MaxHeap do
  defstruct data: []

  defdelegate max_heapify(l, i), to: ListUtils
  defdelegate shift_max(l, i), to: ListUtils

  @doc """
  #Example

      iex> MaxHeap.new()
      %MaxHeap{data: []}
  """
  def new() do
    struct!(__MODULE__)
  end

  @doc """
  #Example

      iex> MaxHeap.new([1,5,4,6,9,])
      %MaxHeap{data: [9, 6, 4, 1, 5]}
  """
  def new(l) when is_list(l) do
    Enum.reduce(l, new(), fn v, m ->
      add(m, v)
    end)
  end

  @doc """
  #Example
      iex> MaxHeap.new() |> MaxHeap.add(1) |>  MaxHeap.add(3)
      %MaxHeap{data: [3, 1]}
  """
  def add(%__MODULE__{data: data} = d, value) do
    new_data = List.insert_at(data, -1, value)
    index = Enum.count(new_data) - 1
    %__MODULE__{d | data: shift_max(new_data, index)}
  end

  def to_list(%__MODULE__{data: data}) do
    data
  end

  @doc """
  #Example 

      iex> MaxHeap.new() |> MaxHeap.add(1) |> MaxHeap.add(3)
      %MaxHeap{data: [3,1]}

      iex> MaxHeap.new() |> MaxHeap.add(1) |> MaxHeap.add(3) |> MaxHeap.max()
      {3, %MaxHeap{data: [1]}}
      
  """
  def max(%__MODULE__{data: []} = dd) do
    {nil, dd}
  end

  def max(%__MODULE__{data: [h | []]} = dd) do
    {h, %__MODULE__{dd | data: []}}
  end

  def max(%__MODULE__{data: [h | data]} = dd) do
    value = h
    last = List.last(data)
    new_data = [last | List.delete_at(data, -1)]
    {value, %__MODULE__{data: max_heapify(new_data, 0)}}
  end

  def top(%__MODULE__{data: []}) do
    nil
  end

  def top(%__MODULE__{data: []}) do
    nil
  end
end

defmodule MinHeap do
  defstruct data: []

  defdelegate min_heapify(l, i), to: ListUtils
  defdelegate shift_min(l, i), to: ListUtils

  @doc """
  #Example

      iex> MinHeap.new()
      %MinHeap{data: []}
  """
  def new() do
    struct!(__MODULE__)
  end

  @doc """
  #Example

      iex> MinHeap.new([9,5,4,6,1,])
      %MinHeap{data: [1, 4, 5, 9, 6]}
  """
  def new(l) when is_list(l) do
    Enum.reduce(l, new(), fn v, m ->
      add(m, v)
    end)
  end

  @doc """
  #Example
      iex> MinHeap.new() |> MinHeap.add(1) |>  MinHeap.add(3)
      %MinHeap{data: [1, 3]}
  """
  def add(%__MODULE__{data: data} = d, value) do
    new_data = List.insert_at(data, -1, value)
    index = Enum.count(new_data) - 1
    %__MODULE__{d | data: shift_min(new_data, index)}
  end

  def to_list(%__MODULE__{data: data}) do
    data
  end

  @doc """
  #Example 

      iex> MinHeap.new() |> MinHeap.add(1) |> MinHeap.add(3)
      %MinHeap{data: [1, 3]}

      iex> MinHeap.new() |> MinHeap.add(1) |> MinHeap.add(3) |> MinHeap.min()
      {1, %MinHeap{data: [3]}}
      
  """
  def min(%__MODULE__{data: [h | data]} = dd) do
    value = h
    last = List.last(data)
    new_data = [last | List.delete_at(data, -1)]
    {value, %__MODULE__{data: min_heapify(new_data, 0)}}
  end
end
