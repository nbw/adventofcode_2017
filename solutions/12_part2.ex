defmodule Pipe do
   defstruct head: 0, children: []
end

defmodule T do
  def ry env \\ "data" do 
    File.read!(Path.relative('solutions/12.#{env}'))
    |> String.split("\n")
    |> Stream.filter(fn(x) -> x != "" end)
    |> Enum.map(fn(row) ->
          row = String.split(row," <-> ")
          c = String.split(List.last(row), ", ")
              |> Enum.map(&(String.to_integer(&1)))
          h = List.first(row)
              |> String.to_integer 
          %Pipe{ head: h, children: c} 
    end)
    |> P.start
  end
end

defmodule P do
  def start input do
    first_children = List.first(input).children
    list = foo(input, first_children)
    remainder = Enum.filter(input, fn(item) -> !Enum.member?(list, item.head) end)
    looper(input, list, remainder)
  end

  def looper _, list, [] do
    list
  end

  def looper input, list, remainder do
    new_list = foo(input,list) 

    if length(list) != length(new_list) do
      new_remainder = Enum.filter(remainder, fn(item) -> !Enum.member?(new_list,item.head) end)
      looper(input, new_list, new_remainder)
    else
      first_children = List.first(remainder).children
      new_rem_list = foo(remainder, first_children)
      new_remainder = Enum.filter(remainder, fn(item) -> !Enum.member?(new_rem_list, item.head) end)
      [list] ++ looper(remainder, new_rem_list, new_remainder)
    end
  end

  def foo [], list do
    Enum.uniq(list)
  end

  def foo [%Pipe{head: h, children: c} | rest], list do
    pipe_contents = [h] ++ c
    if length(list -- pipe_contents) != length(list) do
      list = (list ++ pipe_contents)
    end
    foo(rest,list)
  end
end

