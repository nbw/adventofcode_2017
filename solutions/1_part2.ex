defmodule InverseCaptcha do
  def calculate(input) when is_integer(input) do

    orig_list = Integer.digits(input)
    rotated_list = ListRotate.half_rotate(orig_list)

    foo(0, orig_list, rotated_list)
  end

  def foo(sum, [first | rest], [rot_first | rot_rest]) do
    case first == rot_first do
      true -> 
        foo(sum + first, rest, rot_rest)
      false ->
        foo(sum, rest, rot_rest)
    end
  end

  def foo(sum, [], []) do
    sum
  end
end

defmodule ListRotate do
  def half_rotate list do
    halfway_index = get_halfway_index(list)  
    
    [ first_half, second_half ] = Enum.chunk_every(list, halfway_index)
    second_half ++ first_half
  end
  
  def get_halfway_index list do
    list |> length |> div(2)
  end
end
