# Usage 
#
# T.ry("data")
#
defmodule T do
  def ry(env \\ "test", times \\ 64) do 
    lengths = File.read!(Path.relative("solutions/10.#{env}"))
              |> String.replace("\n","")
              |> String.replace(" ","")
              |> String.codepoints
              |> Enum.map(&(get_ascii(&1)))
              |> (&( &1 ++ [17, 31, 73, 47, 23])).()
              |> IO.inspect

    list = Enum.to_list(0..255) 
    
    K.start(list, lengths, times)
    |> F.start

  end

  def get_ascii letter do
    case letter do
      "1" -> ?1
      "2" -> ?2
      "3" -> ?3
      "4" -> ?4
      "5" -> ?5
      "6" -> ?6
      "7" -> ?7
      "8" -> ?8
      "9" -> ?9
      "0" -> ?0
      "," -> ?,
    end
  end
end


defmodule K do
  def start list, lengths, times do
    run(list, lengths, times)
  end

  def run list, _, 0, _, _ do
    list
  end

  def run list, lengths, rem_times, current_index \\ 0, skip \\ 0 do
    {new_list, new_index, new_skip} = foo(list, lengths, current_index, skip)
    run(new_list, lengths, rem_times - 1, new_index, new_skip)
  end

  def foo master_list, [], current_index, skip do
    {master_list, current_index, skip}
  end

  def foo master_list, [step_head | step_tail], current_index, skip  do
    new_current_index =  case (current_index) >= length(master_list) do
      true -> current_index - div(current_index,length(master_list))*length(master_list)
      false -> current_index
    end

    new_list = get_wrap(master_list, new_current_index, step_head)
    |> replace_with_wrap(master_list, new_current_index)

    next = new_current_index + step_head + skip
    new_index =  case (next) >= length(master_list) do
      true -> next- length(master_list)
      false -> next
    end

    foo(new_list, step_tail, new_index, skip + 1)
  end

  def replace_with_wrap [], master_list, _ do
    master_list
  end

  def replace_with_wrap [head | tail], master_list, index do
    new_index = case (index + 1) >= length(master_list) do
      true -> 0
      false -> index + 1
    end

    m = List.replace_at(master_list, index, head)
    replace_with_wrap(tail, m, new_index)
  end

  def get_wrap _, _, 0, list do
    Enum.reverse(list)
  end

  def get_wrap master_list, index, steps, list \\ [] do
    new_list = list ++ [Enum.at(master_list, index)]

    new_index = case (index + 1) >= length(master_list) do
      true -> 0
      false -> index + 1
    end

    get_wrap(master_list, new_index, steps - 1, new_list)
  end
end


defmodule F do
  use Bitwise

  def start list do

    group_by(list)
    |> Enum.map(&(xor_list(&1)))
    |> Enum.map(&(to_hex(&1)))
    |> Enum.join
    |> String.downcase
  end

  def group_by [], _, result do
    result
  end

  def group_by list, num \\ 16, result \\ [] do
    group = Enum.take(list, num)
    remainder = Enum.drop(list, num)
    group_by(remainder, num, result ++ [group])
  end

  def xor_list [], result \\ 0 do
    result
  end

  def xor_list [head | tail], result do
    xor_list( tail, head ^^^ result)
  end

  def to_hex number do
    res = Integer.to_charlist(number, 16)

    case(length(res) == 1) do
      true -> '0#{res}'
      false -> res
    end
  end
end
