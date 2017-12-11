defmodule T do
  def ry(env \\ "data") do 
    File.read!(Path.relative('solutions/11.#{env}'))
    |> String.replace("\n", "")
    |> String.split(",")
    |> C.tally
  end
end

defmodule C do
  def tally [], _, _, max do
    max
  end
  def tally [head | tail], ns \\ 0, we \\ 0, max \\ 0 do
    max = Enum.max([abs(max), (abs(ns)+abs(we))])
    case head do
      "n" -> tally(tail, ns + 1, we, max)
      "s" -> tally(tail, ns - 1, we, max)
      "w" -> tally(tail, ns, we + 1, max)
      "e" -> tally(tail, ns, we - 1, max)
      "nw" -> tally(tail, ns + 0.5, we + 0.5, max)
      "ne" -> tally(tail, ns + 0.5, we - 0.5, max)
      "sw" -> tally(tail, ns - 0.5, we + 0.5, max)
      "se" -> tally(tail, ns - 0.5, we - 0.5, max)
    end
  end
end
