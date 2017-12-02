# Usage
#
# Checker.parse("1  2  3\n 4  99  101")
#

defmodule Checker do
  def parse(str) do
    String.split(str,"\n")
    |> Stream.map(&process_row(&1))
    |> Stream.map(&(Enum.max(&1) - Enum.min(&1)))
    |> Enum.sum
  end
  def process_row row do
    String.split(row,"  ")
    |> Stream.map(&String.to_integer(&1))
  end
end
