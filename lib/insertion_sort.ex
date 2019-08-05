defmodule InsertionSort do
  @doc """
  Sort array using insertion sort

  #Example
      iex> InsertionSort.sort([1])
      [1]

      iex> InsertionSort.sort([2, 1, 0, 4,5,3])
      [0,1,2,3,4,5]

  """
  def sort([]) do
    []
  end

  def sort([a]) do
    [a]
  end

  def sort([h | array]) do
    insert(h, sort(array))
  end

  defp insert(x, []) do
    [x]
  end

  defp insert(x, [h | acc]) do
    if x <= h do
      [x | [h | acc]]
    else
      [h | insert(x, acc)]
    end
  end
end
