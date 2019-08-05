defmodule DataStructuresTest do
  use ExUnit.Case
  doctest LinkedList
  doctest BinaryTree
  doctest BinaryNode

  doctest TrieNode
  doctest Trie
  doctest SelectionSort
  doctest MergeSort
  doctest InsertionSort

  describe "Trie" do
    test "Insert word into trie" do
      word = "hello"

      trie = 
      Trie.new()
        |> Trie.insert(word)

      assert Trie.get_words(trie) == ["hello"]
    end

    test "Insert word and find in trie" do
      word = "hello"

      trie = 
      Trie.new()
      |> Trie.insert(word)      

      assert Trie.search(trie, word) == true
      assert Trie.search(trie, "hell") == false

      trie = Trie.insert(trie, "hell")
      assert Trie.search(trie, "hell") == true
    end

    test "get all words" do
      word = "hello"
      trie = Trie.new()
      trie = Trie.insert(trie, word)
      assert Trie.search(trie, word) == true
      assert Trie.search(trie, "hell") == false

      trie = Trie.insert(trie, "hell")
      assert Trie.search(trie, "hell") == true

      trie = Trie.insert(trie, "ball")

      trie = 
      trie
      |> Trie.insert("hi")
      |> Trie.insert("hey")
      |> Trie.insert("he")
      |> Trie.insert("home")
      |> Trie.insert("house")
      |> Trie.insert("jay")
      |> Trie.insert("joe")
      
      assert Trie.prefix(trie, "j") == ["joe", "jay"]
      assert Trie.prefix(trie, "ho") == ["house", "home"]
    end
  end
end
