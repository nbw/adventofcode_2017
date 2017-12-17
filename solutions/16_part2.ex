defmodule T do
  def ry times \\ 1000, env \\ "data" do 
    File.read!(Path.relative('solutions/16.#{env}'))
    |> String.replace("\n", "")
    |> String.split(",")
    |> P.start(times)
    |> Enum.join
  end
end

defmodule P do
  @starter ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p"]
  def start instructions, times do
    foo_wrapper(@starter, instructions, times, [])
  end

  def foo_wrapper list, _, 0, master_list do
    list
  end

  def foo_wrapper list, instructions, times, master_list \\ [] do
    new_list = foo(list, instructions)
		new_master = master_list ++ [new_list]
   	 
   	if Enum.member?(new_master, @starter) do 
			IO.puts("Repeat!")
			IO.puts("Calculating 1 billionith value..")
			Enum.at([@starter] ++ new_master, (rem(1_000_000_000, length(new_master))))
		else
			foo_wrapper(new_list, instructions, times - 1, new_master) 
		end
  end

  def foo list, [] do
    list
  end

  def foo list, [ instruction_1 | rest] do
    L.instruction(list, instruction_1) 
    |> foo(rest) 
  end
  
end

defmodule L do
  def instruction list, "s" <> num do
    num = String.to_integer(num)
    spin(list,num)
  end

  def instruction list, "x" <> indexes do
    [i,j] = String.split(indexes, "/") |> Enum.map(&(String.to_integer(&1)))
    swap(list, i, j)
  end

  def instruction list, "p" <> values do
    [val_i,val_j] = String.split(values, "/") 

    i = Enum.find_index(list, &(&1 == val_i))
    j = Enum.find_index(list, &(&1 == val_j))

    swap(list, i, j)
  end

  def swap list, i, j do
    val_i = Enum.at(list,i)
    val_j = Enum.at(list,j)

    list
    |> List.replace_at(j,val_i)
    |> List.replace_at(i,val_j)
  end

  def spin list, 0 do
    list
  end
    
  def spin list, num do
    {val, rem_list } = List.pop_at(list, length(list)-1)
    spin([val] ++ rem_list, num-1)
  end

end

