defmodule Cards do
    @moduledoc """
        Provides methods for creating and handling a deck of cards
    """

    @doc """
        Returns a List of Strings representing a deck of playing cards
    """
    def create_deck do
        values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eigth", "Nine", "Ten", "Jack", "Queen", "King"]
        suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

        for suit <- suits, value <- values do
            "#{value} of #{suit}"
        end
    end

    @doc """
        The List which will be given through the argument `deck` will be shuffled
    """
    def shuffle(deck) do
        Enum.shuffle(deck)
    end

    @doc """
        Checks if the List `deck` contains the Element `cards`

    ## Examples

        iex> deck = Cards.create_deck()
        iex> Cards.contains?(deck, "Ace of Spades")
        true
        iex> Cards.contains?(deck, "Ace of")
        false

    """
    def contains?(deck, card) do
        Enum.member?(deck, card)
    end

    @doc """
        Takes a `deck`as an Argument and splits it into two lists `{hand, rest}` `hand` wil have `hand_size`s length.

    ## Examples

            iex> deck = Cards.create_deck()
            iex> {hand, rest} = Cards.deal(deck, 1)
            iex> hand
            ["Ace of Spades"]

    """
    def deal(deck, hand_size) do
        Enum.split(deck, hand_size)
    end

    def save(deck, filename) do
        binary = :erlang.term_to_binary(deck)
        File.write(filename, binary)
    end

    def load(filename) do
       case File.read(filename) do
        {:ok, deck} ->
            :erlang.binary_to_term deck
        {:error, :enoent} ->
            IO.puts("Error: File is not existing")
            :error
        _else ->
            IO.puts("Error: Unknown Error")
            :error
       end
    end

    def create_hand(hand_size) do
        Cards.create_deck()
        |> Cards.shuffle
        |> Cards.deal(hand_size)
    end
end
