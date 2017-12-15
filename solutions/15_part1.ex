defmodule T do
  def ry do
    D.start
  end
end

defmodule D do
  @a_f 16807
  @b_f 48271
  @divisor 2147483647
  def start a \\ 703, b \\ 516  do
    foo(5_000_000,a,b) 
  end

  def foo 0, _, _, count do
    count
  end

  def foo times, a, b, count \\ 0  do
    a_next = next_value(a, @a_f, 4) 
    b_next = next_value(b, @b_f, 8)

    if compare?(a_next, b_next) do
      count = count + 1 
    end

    foo(times - 1, a_next, b_next, count)
  end

  def next_value i, m, d do
    rem(i*m,@divisor)
  end

  def compare? a,b do
    a_bin = rem(a,65_536)
    b_bin = rem(b,65_536)

    a_bin == b_bin
  end
end
