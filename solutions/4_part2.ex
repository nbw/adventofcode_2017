require IEx
# Usage

# iex> PassPhrase.parse("ab abc cd ab\ndede abc cccc")

defmodule PassPhrase do
  def parse(str) do
    String.split(str,"\n")
    |> Stream.map(&process_row(&1))
    |> Stream.map(&(check_uniq(&1)))
    |> Enum.filter(fn(x) -> x == true end)
    |> length
  end

  def process_row row do
    String.split(row," ")
  end

  def sanitize_item item do
    String.to_charlist(item) 
    |> Enum.sort
  end

  def check_uniq row do
    sanitized_row = Enum.map(row, &(sanitize_item(&1)))
    diff = length(sanitized_row) - length(Enum.uniq(sanitized_row))
    case diff do
      0 -> true
      _ -> false
    end
  end
end
