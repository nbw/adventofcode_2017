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

  def foo [head | tail ], count \\ 0, score \\ 0, garbage \\ false do
    case head do
      "{" ->
        if garbage do
          foo(tail, count, score, garbage)
        else
          foo(tail, count + 1, score, garbage)
        end
      "}" ->
        if garbage do
          foo(tail, Enum.max([0, count]), score, garbage)
        else
          foo(tail, Enum.max([0, count - 1]), score + count, garbage)
        end
      "!" ->
        foo(tl(tail), count, score, garbage)
      "<" ->
        foo(tail, count, score, true)
      ">" ->
        foo(tail, count, score, false)
      _ -> 
        foo(tail, count, score, garbage)
    end
  end

  def foo [], _, score, _ do
    score
  end
end

