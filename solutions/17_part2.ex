defmodule T do
  def ry steps \\ 386, times \\ 50_000_001 do 
    S.start(steps,times)
  end
end

defmodule S do
  def start steps, times do
    foo(1, 0, steps, times)
  end

  def foo _, _, _, 0, len do
    "Value after zero: #{len}"
  end

  def foo len, index, steps, times, last \\ 0 do
    new_index = next(len,index,steps)
    if new_index == 0 do
      last = len
    end
    foo(len+1, new_index+1, steps, times-1, last)
  end

  def next len, index, steps do
    case len > (index+steps) do
      true -> index+steps 
      false -> rem(index+steps,len)
    end
  end
end

