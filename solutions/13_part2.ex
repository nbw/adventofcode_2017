defmodule Wall do
  defstruct dir: 1, pos: 0, size: 0, num: 0

  def increment %Wall{ dir: dir, pos: pos, size: size} = wall do
    case dir do
      1 -> 
        case ((pos + 1) >= size) do
          true ->
            %{ wall | dir: -1, pos: pos - 1}
          false ->
            %{ wall | pos: pos + 1}
        end
     -1 -> 
        case((pos - 1) < 0) do
          true ->
            %{ wall | dir: 1, pos: 1}
          false ->
            %{ wall | pos: pos - 1}
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
    # |> IO.inspect
    |> F.start
  end

  def make_wall size, list_no do
    %Wall{size: size, num: list_no}
  end
end

defmodule F do
  def start(walls) do
    hax(walls)
  end

  def hax walls, delay, 0 do
    delay - 1
  end

  def hax walls, delay \\ 0, result \\ 1  do
    new_walls = delay_walls(walls, delay)
    new_result = foo(0, new_walls, 0)
    hax(walls, delay + 1, new_result)
  end

  def delay_walls walls, 0 do
    IO.inspect walls
    walls
  end

  def delay_walls walls, delay do
    Enum.map(walls, fn(w) ->
      steps = case (delay) >= (2*(w.size-1)) do
        true -> rem(delay,(2*(w.size-1)))
        false -> delay
      end
      if rem(delay, 100000) == 0 do
      IO.puts "Delay: #{delay}, steps: #{steps}, size: #{w.size}"
      end
      delay_wall(w, steps)
    end)
  end

  def delay_wall wall, 0 do
    wall   
  end

  def delay_wall wall, count do
      Wall.increment(wall)
      |> delay_wall(count - 1)
  end

  def foo _, [], sum do
    sum
  end

  def foo position, walls, sum do
    wall = walls |> List.first
    if position < wall.num do
      new_walls = Enum.map(walls, fn(w) ->
        Wall.increment(w)
      end)
      foo(position+1, new_walls, sum)
    else
      new_sum = case(wall.pos == 0) do
        true -> sum + 1
        false -> sum
      end
      new_walls = Enum.map(walls, fn(w) ->
        Wall.increment(w)
      end)
      foo(position+1, tl(new_walls), new_sum)
    end
  end
end
