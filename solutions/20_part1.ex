defmodule T do
  def ry t, env \\ "data" do
    rows = File.read!(Path.relative('solutions/20.#{env}'))
    |> String.split("\n")

    List.delete_at(rows, length(rows)-1)
    |> Enum.map(&(parse_row(&1)))
    |> ParticleHandler.start(t)
  end

  def parse_row row do
    [term | [d_s,v_s,a_s] ] = Regex.run(~r/p=<(.*)>, v=<(.*)>, a=<(.*)>/, row)

    d = String.split(d_s,",") |> Enum.map(&(String.to_integer(&1)))
    v = String.split(v_s,",") |> Enum.map(&(String.to_integer(&1)))
    a = String.split(a_s,",") |> Enum.map(&(String.to_integer(&1)))

    %Particle{d: d, v: v, a: a}
  end
end

defmodule Particle do
   defstruct d: [], v: [], a: []

  def x_values p do
    values(p,0)
  end

  def y_values p do
    values(p,1)
  end

  def z_values p do
    values(p,2)
  end

  defp values p, i do
    d = Enum.at(p.d,i)
    v = Enum.at(p.v,i)
    a = Enum.at(p.a,i)
    {d,v,a}
  end
end

defmodule ParticleHandler do
  def start particles, t do
    distances = Enum.map(particles, fn(p) -> 
      Physics.p_distance(p, t)
    end)
    min = Enum.min(distances)
    closest = Enum.find_index(distances, fn(x) -> x == min end)
    IO.puts("Closest particle is #{closest} of #{length(particles)}")
  end
end

defmodule Physics do

  def p_distance p, t do
    dx = distance(Particle.x_values(p), t)
    dy = distance(Particle.y_values(p), t)
    dz = distance(Particle.z_values(p), t)
    abs(dx) + abs(dy) + abs(dz)
  end

  def distance {d,v,a}, t do
    d + v*t + 0.5*a*t*t
  end
end
  

