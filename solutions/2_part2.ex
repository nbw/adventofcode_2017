# Usage
#
# Checker.parse("1  2  3\n 4  99  101")
#

defmodule Checker do
  def parse(str) do
    String.split(str,"\n")
    |> Stream.map(&process_row(&1))
    |> Stream.map(&(Diviser.process(&1)))
    |> Enum.sum
  end
  def process_row row do
    String.split(row,"  ")
    |> Stream.map(&String.to_integer(&1))
    |> Enum.sort(&(&1 >= &2))
  end
end

defmodule Diviser do
  # assumes that input list is sorted descending
  def process [first| rest] do
    divable?(first, rest) 
  end

  def divable? numer, [next | rest] = list do
    case foo(numer, list) do
      {:yes, val} -> val
      {:no, _ } -> divable?(next, rest)
    end
  end

  def divable? _numer, [] do
    false
  end

  def foo numer, [denom | tail] do
    case rem(numer, denom) do
      0 -> 
        {:yes, div(numer,denom)}
      _ ->
        foo(numer, tail)
    end
  end

  def foo _numer, [] do
    {:no, false}
  end
end

  
