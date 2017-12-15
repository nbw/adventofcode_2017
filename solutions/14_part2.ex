defmodule T do
  def ry(input \\ "jzgqcdpd") do 
    Enum.to_list(0..127)
    |> Stream.map(fn(i) ->
      "#{input}-#{i}"
    end)
    |> Stream.map(fn(s)->
      S.ry(s)
    end)
    |> Enum.map(fn(r) ->
      String.graphemes(r)
    end)
  end
  def print grid do
    Enum.each(grid, fn(row) ->
      Enum.join(row)
      # |> String.replace("0", " ")
      |> IO.puts
    end)
  end
end

defmodule G do
  @grid_size 128

  def start grid do
    grid
  end

  def scan grid, count, nil, nil do
    IO.puts "Count: #{count} -- done!"
    grid
  end

  def scan grid, count \\ 0, r_i \\ 0, c_i \\ 0 do
    if is_point?(grid, r_i, c_i) do
      count = count + 1
      letters = ["A","L","S","T","R","J","H","N", "@", "#","$","%"]
      grid = fill_block(grid, Enum.random(letters), r_i, c_i)
    end
    { r_n, c_i } = next_point(r_i, c_i)
    scan(grid, count, r_n, c_i)
  end

  def fill_block grid, count, r_i, c_i do
    grid = replace_val(grid, count, r_i, c_i)
    grid = case left(grid, r_i, c_i) do
      {:ok, {r,c}} -> if(is_point?(grid, r, c)) do
          fill_block(grid, count, r, c)
        else
          grid
        end
      {:error, _} -> grid
    end
    grid = case right(grid, r_i, c_i) do
      {:ok, {r,c}} -> if(is_point?(grid, r, c)) do
          fill_block(grid, count, r, c)
        else
          grid
        end
      {:error, _} -> grid
    end
    grid = case down(grid, r_i, c_i) do
       {:ok, {r,c}} -> if(is_point?(grid, r, c)) do
           fill_block(grid, count, r, c)
         else
           grid
         end
       {:error, _} -> grid
     end
    grid = case up(grid, r_i, c_i) do
       {:ok, {r,c}} -> if(is_point?(grid, r, c)) do
           fill_block(grid, count, r, c)
         else
           grid
         end
       {:error, _} -> grid
     end
  end

  def replace_val grid, val, r, c do
    new_row = List.replace_at(Enum.at(grid,r),c,val)
    List.replace_at(grid, r, new_row)
  end

  def left grid, r_i, c_i do
    case (c_i - 1) >= 0 do
      true -> {:ok, {r_i, c_i - 1}}
      false -> {:error, "outside grid"}
    end
  end

  def right grid, r_i, c_i do
    case (c_i + 1) < @grid_size do
      true -> {:ok, {r_i, c_i + 1}}
      false -> {:error, "outside grid"}
    end
  end
  
  def up grid, r_i, c_i do
    case (r_i - 1) >= 0 do
      true -> {:ok, {r_i - 1, c_i}}
      false -> {:error, "outside grid"}
    end
  end

  def down grid, r_i, c_i do
    case (r_i + 1) < @grid_size do
      true -> {:ok, {r_i + 1, c_i}}
      false -> {:error, "outside grid"}
    end
  end

  def next_point(r, c) do
    case (c + 1) >= @grid_size do
      true -> 
        case (r+1) >= @grid_size do
          true -> {nil, nil}
          false -> {r+1, 0}
        end
      false -> {r, c+1}
    end
  end

  def is_point?(grid, r, c) do
    G.at(grid,r,c) == "1"
  end

  def at grid, row, col do
    Enum.at(grid, row)
    |> Enum.at(col)
  end
end

defmodule S do
  def ry(input, times \\ 64) do 
    lengths = input
              |> String.codepoints
              |> Enum.map(&(get_ascii(&1)))
              |> (&( &1 ++ [17, 31, 73, 47, 23])).()

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
      "-" -> ?-
      "a" -> ?a
      "c" -> ?c
      "d" -> ?d
      "e" -> ?e
      "f" -> ?f
      "g" -> ?g
      "k" -> ?k
      "j" -> ?j
      "l" -> ?l
      "n" -> ?n
      "p" -> ?p
      "q" -> ?q
      "r" -> ?r
      "x" -> ?x
      "z" -> ?z
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
    |> Stream.map(&(xor_list(&1)))
    |> Stream.map(&(to_hex(&1)))
    |> Stream.map(&(to_binary_from_hex(&1)))
    |> Enum.join
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
  def to_binary_from_hex hex do
    hex
    |> Stream.map(fn(h) ->
      h_str = to_string(h)
      case h_str do
        "48" -> "0000"
        "49" -> "0001"
        "50" -> "0010"
        "51" -> "0011"
        "52" -> "0100"
        "53" -> "0101"
        "54" -> "0110"
        "55" -> "0111"
        "56" -> "1000"
        "57" -> "1001"
        "65" -> "1010"
        "66" -> "1011"
        "67" -> "1100"
        "68" -> "1101"
        "69" -> "1110"
        "70" -> "1111"
      end
    end)
    |> Enum.join
  end
end
