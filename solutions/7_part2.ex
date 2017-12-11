defmodule Parser do
  def to_list input do
    list = String.split(input,"\n")
            |> Enum.map(&(parse_row(&1)))
            |> TreeMaker.find_and_build("ykpsek")
  end

  def parse_row(row) do
    %{ 
      head: get_head(row),
      weight: get_weight(row),
      children: get_children(row)
    }
  end

  def get_weight(row) do
    String.split(row,"(")
    |> List.last
    |> String.split(")")
    |> List.first
    |> String.to_integer
  end

  def get_head(row) do
    head = String.split(row, " (")
    |> List.first

    head
  end

  def get_children(row) do
    case String.contains?(row,"->") do
      true ->
        String.split(row, "-> ")
        |> List.last
        |> String.split(", ")
      false -> []
    end
  end
end

defmodule TreeNode do
   defstruct head: 0, weight: 0, total: 0, children: []
end

defmodule TreeMaker do

  def find_and_build(list, name) do
    item = find(name,list)
    case item do
      nil -> nil
      _ -> create_node(list, item)
    end
  end

  def create_node list, %{ head: head, weight: weight, children: children } do
    c = Enum.map(children, fn(child_name) -> 
          find_and_build(list, child_name) 
        end)
        |> Enum.filter( & !is_nil(&1))

    total = Enum.map(c, fn(x) -> x.total end) |> Enum.sum |> add(weight)

    %TreeNode{head: head, weight: weight, total: total, children: c}
  end

  def add(a,b) do
    a + b
  end

  def find(name, list) do
    Enum.find(list, fn(item) -> item[:head] == name end)
  end

  def print(tree, level \\ 0, child_total \\ 0) do
      vals = Enum.map(tree.children, &(&1.total))
      if level == 3 do
        if length(Enum.uniq(vals)) > 1 do
        IO.puts("#{level}: #{Integer.to_string(tree.total)} (#{child_total})")
        IO.puts "weight: #{tree.weight}    len: #{length(vals)}"
        IO.inspect vals
        IO.puts "_____________"
        end
      end
    Enum.each(tree.children, &(print(&1,level+1, length(vals))))
  end
end

