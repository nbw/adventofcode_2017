defmodule S do
  use GenServer

  def start_link(default) do
    GenServer.start_link(__MODULE__, 
                         %{
                           name: Integer.to_string(default),
                           ledger: %{ "p" => default},
                           index: 0,
                           stack: [],
                           deadlock: false
                         }
    )
  end

  def current(pid) do
    GenServer.call(pid, :current)
  end

  def instruction(pid, input) do
    GenServer.call(pid, {:execute, input})
  end

  def store_send(pid, value) do
    GenServer.call(pid, {:push, value})
  end

  def receive(pid, reg) do
    GenServer.call(pid, {:receive, reg})
  end

  # private handlers 
  
  def handle_call({:push, value}, _from, %{ledger: ledger, stack: stack, index: index} = state) do 
    {:reply, {ledger, index + 1}, %{ state | stack: stack ++ [value], index: index + 1 }} 
  end

  # set deadlock
  def handle_call({:receive, reg}, _from, %{name: name, stack: []} = state) do 
    {:reply, "Deadlock: #{name}", %{ state | deadlock: true }} 
  end

  def handle_call({:receive, reg}, _from, %{ledger: ledger, index: index, stack: [val | t] } = state) do 
    { new_ledger, new_index } = D.instruction(ledger, index, "set #{reg} #{val}" )
    {:reply, new_ledger, %{state | ledger: new_ledger, index: new_index}} 
  end

  def handle_call(:current, _from, state) do 
    {:reply, state, state} 
  end

  def handle_call({:execute, inst}, _from, %{ledger: ledger, index: index } = state) do 
    { new_ledger, new_index } = D.instruction(ledger, index, inst, name, nil)
    {:reply, new_ledger, %{state | ledger: new_ledger, index: new_index}} 
  end
end


defmodule T do
  def ry env \\ "data" do
    File.read!(Path.relative('solutions/18.#{env}'))
    |> String.split("\n")
    # |> D.start

    {:ok, p0} = S.start_link(0)
    {:ok, p1} = S.start_link(1)
    
    %{ 
      "0" => p0,
      "1" => p1
    }
  end
end

defmodule D do
  def start instructions do
    ledger = %{ "snd" => 1 }
    foo(ledger, instructions, 0)
  end

  def foo ledger, instructions, index do
    i = Enum.at(instructions,index) 
    { new_ledger, new_index } = instruction(ledger, index, i, nil, nil)

    if new_ledger == :ok do
      IO.puts "Found: #{new_index}"
    else
      foo(new_ledger, instructions, new_index)
    end
  end

  def instruction ledger, inst_index, "rcv " <> reg, sender, pids do
    receiver = Map.fetch!(pids, sender)
    S.receive(receiver, reg)
  end

  def instruction ledger, inst_index, "snd " <> val, sender, pids do
    receiver = case sender do
      "0" -> Map.fetch!(pids, "1") 
      "1" -> Map.fetch!(pids, "0") 
    end

    IO.puts("Send #{receiver}: #{val}")
    S.store_send(receiver,val)

    {ledger, inst_index + 1}
  end

  def instruction ledger, inst_index, "set " <> values, _sender, _pids do
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

  def instruction ledger, inst_index, "add " <> values, _sender, _pids  do
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

  def instruction ledger, inst_index, "mul " <> values, _sender, _pids do
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

  def instruction ledger, inst_index, "mod " <> values, _sender, _pids do
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


  def instruction ledger, inst, inst_index, "jgz " <> values, _sender, _pids do
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


