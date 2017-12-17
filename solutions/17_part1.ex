defmodule T do
  def ry steps \\ 386, times \\ 2017 do 
    S.start(steps,times)
  end
end

defmodule S do
  def start steps, times do
    foo([0], 0, 1, steps, times)
  end

  def foo list, index, _, _, 0 do
    new_index = next(list,index,1)
    Enum.at(list, new_index)
  end

  def foo list, index, count, steps, times do
    new_index = next(list,index,steps)+1
    new_list = List.insert_at(list, new_index, count)
    foo(new_list, new_index, count+1, steps, times-1)
  end

  def next list, index, steps do
    case length(list) > (index+steps) do
      true -> index+steps 
      false -> rem(index+steps,length(list))
    end
  end
end
