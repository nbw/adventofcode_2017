# Usage
#
# Put data in 9.data
# 
# run T.ry
#
defmodule T do
  def ry do 
    File.stream!(Path.relative('solutions/9.data'), [], 1) |> Enum.to_list
    |> Streamer.start
  end
end

defmodule Streamer do
  def start input do
    foo(input)
  end

  def foo [head | tail ], count \\ 0, score \\ 0, garbage \\ false, garbage_count \\ 0 do
    case head do
      "{" ->
        if garbage do
          foo(tail, count, score, garbage, garbage_count + 1)
        else
          foo(tail, count + 1, score, garbage, garbage_count)
        end
      "}" ->
        if garbage do
          foo(tail, Enum.max([0, count]), score, garbage, garbage_count+1)
        else
          foo(tail, Enum.max([0, count - 1]), score + count, garbage, garbage_count)
        end
      "!" ->
        foo(tl(tail), count, score, garbage, garbage_count)
      "<" ->
        if garbage do
          foo(tail, count, score, garbage, garbage_count+1)
        else
          foo(tail, count, score, true, garbage_count)
        end
      ">" ->
        foo(tail, count, score, false, garbage_count)
      _ -> 
        if garbage do
          foo(tail, count, score, garbage, garbage_count+1)
        else
          foo(tail, count, score, garbage, garbage_count)
        end
    end
  end

  def foo [], _, _, _, garbage_count do
    garbage_count
  end
end

