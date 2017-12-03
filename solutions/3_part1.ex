defmodule Spiral do
  def process input do
    ring_deltas = calc_ring_deltas(input, 0, [1]) 
    ring_max = Enum.sum(ring_deltas)
    ring_num = length(ring_deltas)
    
    side_length = find_side_length(ring_num)

    find_side_range(input, side_length, ring_max)
    |> distance(input, ring_num)
  end

  def calc_ring_deltas goal, ring_num, current_list do
    case Enum.sum(current_list) >= goal do
      true -> current_list
      false -> 
        next_ring = ring_num + 1
        new_list = current_list ++ [next_ring * 8]
        calc_ring_deltas(goal, next_ring, new_list)
    end
  end

  def find_side_length ring_num do
    2*ring_num - 1
  end

  def find_side_range input, side_length, max do
    min = max - side_length + 1
    case(min <= input) do
      true -> Enum.to_list(min..max)
      false -> find_side_range(input, side_length, min)
    end
  end

  def distance_from_middle list, value do
    value_index = Enum.find_index(list, fn(x) -> x == value end) 
                  
    abs(value_index - ((length(list)-1)/2 + 1))
  end

  def distance list, value, ring_num do
    ring_num + distance_from_middle(list, value)
  end
end
