defmodule TrieNode do
  defstruct is_word: false,
            word: nil,
            char: nil,
            nodes: %{}

  def new() do
    struct(__MODULE__)
  end

  def new(char) do
    struct(__MODULE__, char: char)
  end
end

defmodule Trie do
  defstruct root: nil

  def new() do
    struct!(__MODULE__, root: TrieNode.new())
  end

  @doc """
  Create a trie from a list of words

  #Example
      iex> t = Trie.from_list(["hello", "hell"])
      iex> Trie.get_words(t)
      ["hello", "hell"]
  """
  def from_list(words) when is_list(words) do
    Enum.reduce(words, new(), fn w, t ->
      insert(t, w)
    end)
  end

  @doc """
  Insert a new word into trie

  #Example
      # iex> t = Trie.new()
      # iex> Trie.insert(t, "hello")
      # %Trie{root: %TrieNode{nodes: %{"h"=> %TrieNode{char: "h"}}}}        
  """
  def insert(%__MODULE__{} = trie, word) do
    %{trie | root: insert_from(trie.root, to_charlist(word), word)}
  end

  @doc """
  Search for a word in trie and return true if present

  #Example
      iex> t = Trie.new()
      iex> t = Trie.insert(t, "hello")
      iex> Trie.search(t, "hello")
      true
      
  """
  def search(%__MODULE__{} = trie, word) do
    {found, _} = search_word(trie.root, to_charlist(word))
    found
  end

  @doc """
  Finds all words with the given prefix

  Words are take from the bag instead of 
  building from chars in the tree path

  #Example
      iex> t = Trie.from_list(["he", "hello", "joe"])
      iex> Trie.prefix(t, "h")
      ["hello", "he"]
  """
  def prefix(trie, prefix) do
    # find the node to the prefix
    {found, node} = search_word(trie.root, to_charlist(prefix))

    if is_nil(node) do
      []
    else
      if found do
        [
          prefix
          | Enum.map(get_words(Map.values(node.nodes), []), fn suffix ->
              "#{suffix}"
            end)
        ]
      else
        Enum.map(get_words(Map.values(node.nodes), []), fn suffix ->
          "#{suffix}"
        end)
      end
    end
  end

  @doc """
  Finds all words with the given prefix

  Words built from chars in the tree path instead 
  of from bags

  #Example
      iex> t = Trie.from_list(["he", "hello", "joe"])
      iex> Trie.prefix(t, "h")
      ["hello", "he"]
  """
  def prefix2(trie, prefix) do
    # find the node to the prefix
    {found, node} = search_word(trie.root, to_charlist(prefix))

    if is_nil(node) do
      []
    else
      if found do
        [
          prefix
          | Enum.map(get_words2(node.nodes), fn suffix ->
              "#{prefix}#{suffix}"
            end)
        ]
      else
        Enum.map(get_words(node.nodes), fn suffix ->
          "#{prefix}#{suffix}"
        end)
      end
    end
  end

  @doc """
  Get all words from the trie.    
  Also words are take by building
  from chars in tree path
  #Example
      iex> t = Trie.from_list(["hello", "joe", "mike"])
      iex> Trie.get_words(t)
      ["mike", "joe", "hello"]
  """
  def get_words2(%__MODULE__{} = trie) do
    get_words2(trie.root.nodes)
  end

  def get_words2(map) when is_map(map) do
    # IO.inspect(Map.keys(map), label: "Get words2")

    Enum.reduce(map, [], fn {c, v}, l2 ->
      l2 =
        if v.is_word do
          ["#{c}" | l2]
        else
          l2
        end

      # IO.inspect(Map.keys(v.nodes), label: "Children nodes for #{c}")
      suffixes = get_words2(v.nodes)
      # IO.inspect([c, suffixes], label: "Suffixes for #{c}")

      l4 =
        Enum.reduce(suffixes, l2, fn wd, l3 ->
          ["#{c}#{wd}" | l3]
        end)

      # IO.inspect([l2,l4,v.is_word], label: "List so far")
      # IO.inspect([l4, v.is_word], label: "Final?")
      l4
    end)
  end

  @doc """
  Get all words from the trie.
  The method uses DFS to return all words
  Also words are take from the the bag instead of building
  from chars in tree path

  #Example
      iex> t = Trie.from_list(["hello", "joe", "mike"])
      iex> Trie.get_words(t)
      ["mike", "joe", "hello"]
  """
  def get_words(%__MODULE__{} = trie) do
    get_words(Map.values(trie.root.nodes), [])
  end

  defp get_words([], acc) do
    acc
  end

  defp get_words(nodes, words) do
    n = hd(nodes)
    rest = tl(nodes)

    new_nodes = List.flatten([Map.values(n.nodes), rest])

    new_words =
      if n.is_word do
        [n.word | words]
      else
        words
      end

    get_words(new_nodes, new_words)
  end

  defp insert_from(node, [c], word) do
    new_node =
      case Map.get(node.nodes, c) do
        %TrieNode{} = n ->
          n

        _ ->
          TrieNode.new(c)
      end

    nodes = Map.put(node.nodes, c, %{new_node | word: word, is_word: true})
    %{node | nodes: nodes}
  end

  defp insert_from(node, [c | rest], word) do
    # IO.inspect([node, c, rest], label: "Insert data")

    case Map.get(node.nodes, c) do
      %TrieNode{} = n ->
        new_node = insert_from(n, rest, word)
        nodes = Map.put(node.nodes, c, new_node)
        %{node | nodes: nodes}

      _ ->
        n = insert_from(TrieNode.new(c), rest, word)
        nodes = Map.put(node.nodes, c, n)

        %{node | nodes: nodes}
    end
  end

  defp search_word(node, [c]) do
    case Map.get(node.nodes, c) do
      %TrieNode{is_word: is_word} = n ->
        {is_word, n}

      _ ->
        {false, nil}
    end
  end

  defp search_word(node, [c | rest]) do
    case Map.get(node.nodes, c) do
      %TrieNode{} = n ->
        search_word(n, rest)

      _ ->
        {false, nil}
    end
  end
end
