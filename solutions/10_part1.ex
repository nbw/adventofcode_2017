defmodule T do
  def ry do 
    File.read!(Path.relative('solutions/10.data'))
    |> String.replace("\n","")
    |> String.replace(" ", "")
    |> String.split(",")
    |> Enum.map(&(String.to_integer &1))
    |> K.start
  end
end

defmodule K do
  def start input do
    result = Enum.to_list(0..255)
    |> foo(input)

    Enum.at(result, 0) * Enum.at(result, 1)
  end

  def foo master_list, [], current_index, skip do
    master_list
  end

  def foo master_list, [step_head | step_tail], current_index \\ 0, skip \\ 0  do
    new_list = get_wrap(master_list, current_index, step_head)
    |> replace_with_wrap(master_list, current_index)

    next = current_index + step_head + skip
    new_index =  case (next) >= length(master_list) do
      true -> next-length(master_list)
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
