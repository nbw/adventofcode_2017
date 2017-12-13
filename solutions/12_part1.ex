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
    list = foo(input, [])
    looper(input, list)
  end

  def looper input, list do
    new_list = foo(input,list) 

    if length(list) != length(new_list) do
      looper(input, new_list)
    else
      list
    end
  end

  def foo [], list do
    Enum.uniq(list)
  end

  def foo [%Pipe{head: 0, children: c} | rest], [] do
    foo(rest, [0] ++ c)
  end

  def foo [%Pipe{head: h, children: c} | rest], list do
    pipe_contents = [h] ++ c
    if length(list -- pipe_contents) != length(list) do
      list = (list ++ pipe_contents)
    end
    foo(rest,list)
  end
end

