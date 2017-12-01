defmodule InverseCaptcha do
  def calculate(input) when is_integer(input) do
    [first | rest ] = Integer.digits(input)
    foo(0, first, rest ++ [first])
  end

  def foo(sum, first, [second | rest]) do
    case first == second do
      true -> 
        foo(sum + first, second, rest)
      false ->
        foo(sum, second, rest)
    end
  end

  def foo(sum, _last_item, []) do
    sum
  end
end
