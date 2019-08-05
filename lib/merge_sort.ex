defmodule MergeSort do
  @doc """
  Sort array using merge sort

  #Example
    iex> arr = [5, 0, 4, 3,2,1,2]
    iex> MergeSort.sort(arr)
    [0,1,2,2,3,4,5]
  """
  def sort(array) do
    msort(array)
  end

  defp msort([]) do
    []
  end

  defp msort([a]) do
    [a]
  end

  defp msort([h | r] = a) do
    merge(msort(r), [h])
  end

  @doc """
  Merge two sorted arrays into a single sorted array

  #Example
    iex> arr1 = [1,2,4,5]
    iex> arr2 = [0,2,3,6]
    iex> MergeSort.merge(arr1, arr2)
    [0, 1, 2,2,3,4,5,6]
  """
  defp merge(arr1, arr2) do
    merge(arr1, arr2, [])
  end

  defp merge([], arr2, acc) do
    acc ++ arr2
  end

  defp merge(arr1, [], acc) do
    acc ++ arr1
  end

  defp merge([h | arr1], [h2 | _] = arr2, acc) when h < h2 do
    merge(arr1, arr2, acc ++ [h])
  end

  defp merge([h | _] = arr1, [h2 | arr2], acc) when h2 < h do
    merge(arr1, arr2, acc ++ [h2])
  end

  defp merge([h | arr1], [h2 | arr2], acc) when h == h2 do
    merge(arr1, arr2, acc ++ [h2, h])
  end
end
