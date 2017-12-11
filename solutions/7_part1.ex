defmodule Parser do
  def to_list input do
    list = String.split(input,"\n")

    heads = Enum.map(list, &(get_head(&1)))
            |> List.flatten

    tails = Enum.map(list, &(get_tail(&1)))
            |> List.flatten

    heads -- tails

  end

  def split_list(row) do
    head = get_head(row)
    tail = get_tail(row)
    
  end

  def get_head(row) do
    head = String.split(row, " (")
    |> List.first

    [head]
  end

  def get_tail(row) do
    case String.contains?(row,"->") do
      true ->
        String.split(row, "-> ")
        |> List.last
        |> String.split(", ")
      false -> []
    end
  end
end
