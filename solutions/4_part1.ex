# Usage

# iex> PassPhrase.parse("ab abc cd ab\ndede abc cccc")

defmodule PassPhrase do
  def parse(str) do
    String.split(str,"\n")
    |> Stream.map(&process_row(&1))
    |> Stream.map(&(check_uniq(&1)))
    |> Enum.filter(fn(x) -> x == true end)
  end

  def process_row row do
    String.split(row," ")
  end

  def check_uniq row do
    diff = length(row) - length(Enum.uniq(row))
    case diff do
      0 -> true
      _ -> false
    end
  end
end
