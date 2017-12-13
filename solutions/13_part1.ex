defmodule Wall do
  defstruct dir: 1, pos: 0, size: 0, num: 0

  def increment %Wall{ dir: dir, pos: pos, size: size, num: num} do
    case dir do
      1 -> 
        case ((pos + 1) >= size) do
          true ->
            %Wall{ dir: -1, pos: pos - 1, size: size, num: num}
          false ->
            %Wall{ dir: 1, pos: pos + 1, size: size, num: num}
        end
     -1 -> 
        case((pos - 1) < 0) do
          true ->
            %Wall{ dir: 1, pos: 1, size: size, num: num}
          false ->
            %Wall{ dir: -1, pos: pos - 1, size: size, num: num}
        end
    end
  end
end

defmodule T do
  def ry env \\ "data" do 
    File.read!(Path.relative('solutions/13.#{env}'))
    |> String.split("\n")
    |> Stream.filter(fn(x) -> x != "" end)
    |> Enum.map(fn(row) ->
      items = String.split(row,": ")

      list_no = items 
      |> List.first
      |> String.to_integer

      size = items
      |> List.last
      |> String.to_integer

      make_wall(size, list_no)
    end)
    |> IO.inspect
    |> F.start
  end

  def make_wall size, list_no do
    %Wall{size: size, num: list_no}
  end
end

defmodule F do
  def start(walls) do
    foo(0, walls, 0)
  end

  def foo _, [], sum do
    sum
  end

  def foo position, walls, sum do
    wall = walls |> List.first
      # IO.puts("position: #{position}, wall_p: #{wall.pos}, sum: #{sum}, wall_n: #{wall.num}")
    if position < wall.num do
      new_walls = Enum.map(walls, fn(w) ->
        Wall.increment(w)
      end)
      foo(position+1, new_walls, sum)
    else
      new_sum = case(wall.pos == 0) do
        true -> position * wall.size
        false -> sum
      end
      new_walls = Enum.map(walls, fn(w) ->
        Wall.increment(w)
      end)
      foo(position+1, tl(new_walls), new_sum)
    end
  end
end
