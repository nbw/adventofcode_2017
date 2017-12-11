# d dec 461 if oiy <= 1
# phf dec -186 if eai != -2
# oiy inc 585 if lk >= 9
# bz dec -959 if gx < 9
# vyo inc -735 if hnh > -7

# Parser.start(input) |> Ledger.start

defmodule Parser do
  def start input do
    list = String.split(input,"\n")
  end
end

defmodule Ledger do
  def start [], ledger, max do
    max
  end
  def start [head | tail], ledger \\ %{}, max \\ 0 do
    [ key,
      operation,
      amount,
      _,
      clause_var,
      operator,
      clause_amount
    ] = String.split(head," ")

    expression =  "#{get(ledger,clause_var)} #{operator} #{clause_amount}" 
    {bool, _ } = Code.eval_string(expression, [])

    case bool do
      true -> 
        ledger = action(operation, ledger, key, String.to_integer(amount))
        new_val = get(ledger, key)
        if new_val > max do
          max = new_val
        end
        start(tail, ledger, max)
      false ->
        start(tail, ledger, max)
    end

  end

  def action("dec", ledger, key, amount) do
    value = get(ledger, key) - amount
    set(ledger, key, value)
  end

  def action("inc", ledger, key, amount) do
    set(ledger, key, get(ledger, key) + amount)
  end

  def set ledger, key, value do
    check(ledger,key)
    |> Map.replace(key, value)
  end

  def check ledger, key do
    case val = Map.get(ledger, key) do
      nil -> 
        Map.put_new(ledger, key, 0)
      _ -> ledger
    end
  end

  def get ledger, key do
    case val = Map.get(ledger, key) do
      nil -> 0
      _ -> val
    end
  end
end

