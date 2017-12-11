defmodule T do
  def ry(env \\ "data") do 
    File.read!(Path.relative('solutions/11.#{env}'))
    |> String.replace("\n", "")
    |> String.split(",")
    |> C.tally
  end
end

defmodule C do
  def tally [], ns, we do
    IO.puts("ns: #{ns}")
    IO.puts("we: #{we}")
    (abs(ns) + abs(we))
  end
  def tally [head | tail], ns \\ 0, we \\ 0 do
    case head do
      "n" -> tally(tail, ns + 1, we)
      "s" -> tally(tail, ns - 1, we)
      "w" -> tally(tail, ns, we + 1)
      "e" -> tally(tail, ns, we - 1)
      "nw" -> tally(tail, ns + 0.5, we + 0.5)
      "ne" -> tally(tail, ns + 0.5, we - 0.5)
      "sw" -> tally(tail, ns - 0.5, we + 0.5)
      "se" -> tally(tail, ns - 0.5, we - 0.5)
    end
  end
end
