defmodule Parser do
  def to_list input do
    String.split(input,"\n")
    |> Enum.map(&String.to_integer(&1))
  end
end

defmodule Traverser do
  def start list do
    foo( 0, list, 0)
  end
  def foo index, list, count do
    case Enum.fetch(list, index) do
      {:ok, val} -> 
        new_list = case val >= 3 do
          true  -> List.replace_at(list, index, val - 1)
          false -> List.replace_at(list, index, val + 1)
        end
        foo(index + val, new_list, count+1)
      :error -> count
    end
  end
end
