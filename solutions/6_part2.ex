# Usage
#
# Traverser.start([2,1,4,1])

defmodule Traverser do
  def start list do
    foo(list)
  end
  def foo list, count \\ 1, ledger \\ [] do
    max_val = get_max(list)
    max_val_index = get_max_index(list)

    distrib_list = List.replace_at(list, max_val_index, 0) 
    |> distribute( max_val_index + 1, max_val)

    case Enum.member?(ledger, distrib_list) do
      true ->
        count - Enum.find_index(ledger, &(&1 == distrib_list)) - 1 
      false ->
        foo(distrib_list, count + 1, ledger ++ [distrib_list])
    end
  end

  def distribute list, _index, 0 do
    list
  end

  def distribute list, index, val do
    index = case index >= length(list) do
      true -> 0
      false -> index
    end

    List.update_at(list, index, &(&1 + 1))
    |> distribute(index + 1, val - 1)
  end

  def get_max list do
    Enum.max(list)
  end

  def get_max_index list do
    val = get_max(list)
    Enum.find_index(list, fn(x) -> x == val end)
  end
end
