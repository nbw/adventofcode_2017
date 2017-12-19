defmodule T do
  def ry env \\ "data" do
    File.read!(Path.relative('solutions/18.#{env}'))
    |> String.split("\n")
    |> D.start
  end
end

defmodule D do
  def start instructions do
    ledger = %{ "snd" => 1 }
    foo(ledger, instructions, 0)
  end

  def foo ledger, instructions, index do
    i = Enum.at(instructions,index) 
    { new_ledger, new_index } = instruction(ledger, instructions, index, i)

    if new_ledger == :ok do
      IO.puts "Found: #{new_index}"
    else
      foo(new_ledger, instructions, new_index)
    end
  end

  def instruction ledger, inst, inst_index, "snd " <> reg do
    value = Map.get(ledger, reg) 
    # IO.puts "Sound: #{value}"
    ledger = Map.put(ledger, "snd", reg)
    {ledger, inst_index + 1}
  end

  def instruction ledger, inst, inst_index, "set " <> values do
    [ key , val ] = String.split(values, " ")

    set_val = get_value(ledger, val)

    new_ledger = case Map.has_key?(ledger, key) do
      true ->
        curr_val = Map.get(ledger, key) 
        Map.replace(ledger, key, set_val)
      false -> 
        Map.put_new(ledger, key, set_val)
    end

    {new_ledger, inst_index + 1}
  end

  def instruction ledger, inst, inst_index, "add " <> values do
    [ key , val ] = String.split(values, " ")
    add_val = get_value(ledger, val)

    new_ledger = case Map.has_key?(ledger, key) do
      true ->
        curr_val = Map.get(ledger, key) 
        Map.replace(ledger, key, curr_val + add_val)
      false -> 
        Map.put_new(ledger, key, add_val)
    end

    {new_ledger, inst_index + 1}
  end

  def instruction ledger, inst, inst_index, "mul " <> values do
    [ key , val ] = String.split(values, " ")
    curr_val = Map.get(ledger, key, 0) 

    mult_val = get_value(ledger, val)

    new_ledger = case Map.has_key?(ledger, key) do
      true ->
        curr_val = Map.get(ledger, key) 
        Map.replace(ledger, key, curr_val * mult_val)
      false -> 
        Map.put_new(ledger, key, 0)
    end

    {new_ledger, inst_index + 1}
  end

  def instruction ledger, inst, inst_index, "mod " <> values do
    [ key , val ] = String.split(values, " ")
    curr_val = Map.get(ledger, key, 0) 

    mod_val = get_value(ledger, val)
    new_ledger = case Map.has_key?(ledger, key) do
      true ->
        curr_val = Map.get(ledger, key) 
        Map.replace(ledger, key, rem(curr_val,mod_val))
      false -> 
        Map.put_new(ledger, key, 0)
    end

    {new_ledger, inst_index + 1}
  end

  def instruction ledger, inst, inst_index, "rcv " <> values do
    reg = Map.get(ledger, "snd") 
    value = Map.get(ledger, reg) 
    if value == 0 do
      IO.puts("recovered '#{reg}': #{value}")
      { ledger, inst_index + 1}
    else
      {:ok, value}
    end
  end

  def instruction ledger, inst, inst_index, "jgz " <> values do
    [ key , jumps ] = String.split(values, " ")

    new_index = if Map.get(ledger, key, 0) > 0 do
      jump_val = get_value(ledger, jumps)
      inst_index + jump_val 
    else
      inst_index + 1 
    end
    { ledger, new_index}
  end

  def get_value ledger, val do
    if Regex.match?(~r/^[A-z]+$/,val) do
      Map.get(ledger, val, 0) 
    else
      String.to_integer(val) 
    end
  end
end

