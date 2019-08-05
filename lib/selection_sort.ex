defmodule SelectionSort do
  @doc """
  Sort array using selection sort

  #Example
      iex> SelectionSort.sort([1])
      [1]

      iex> SelectionSort.sort([2, 1])
      [1, 2]

      iex> SelectionSort.sort([5, 2, 1, 3, 4, 0])
      [0, 1, 2,3,4,5]

      iex> SelectionSort.sort([5, 2, 1,9, 7, 3, 4, 0])
      [0, 1, 2,3,4,5,7,9]
  """

  def sort([]) do
    []
  end

  def sort([_a] = array) do
    array
  end

  def sort(array) do
    do_sort(array, [])
  end

  def do_sort([], acc) do
    acc
  end

  def do_sort(array, acc) do
    min = get_min(array)
    do_sort(array -- [min], acc ++ [min])
  end

  def get_min([h]) do
    h
  end

  def get_min([h | [h1 | r]]) do
    if h <= h1 do
      get_min([h | r])
    else
      get_min([h1 | r])
    end
  end
end
