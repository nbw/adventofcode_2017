defmodule Parser do
  def to_list input do
    String.split(input,"\n")
    |> Enum.map(&(split_row(&1)))
  end
  def split_row(head <> " (" <> weight <> ") -> " children) do
    [head] ++ String.split(children,",")
  end
  def split_row(head <> " (" <> weight <> ")") do
    [head]
  end
end
