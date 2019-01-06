defmodule UserInput do
  defstruct [:a, :b, :c, :d]
  def main(wallet, block_size, num_transaction, tgt, dc) do
    # IO.inspect args
    # [, block_size]=args
    # IO.inspect wallet
    # IO.inspect dc
    if num_transaction > 0 do
      retake(wallet, block_size, num_transaction, tgt, dc)
    else
      IO.puts("\n ##### Performed all transactions #### \n")
      IO. puts "Final wallet --->  #{inspect (wallet)} \n";
      exit(:normal)
    end

    # System.argv()
  end


  def retake(updated_input, block_size, num_transaction, tgt, chain) do
    # track = %TakeInput{}
    # IO.inspect %TakeInput{}
    sender_address = IO.gets("Enter sender's address --> ")
    sender_address = String.trim(sender_address) |> String.to_atom()
    receiver_address = IO.gets("Enter receiver's address --> ")
    receiver_address = String.trim(receiver_address) |> String.to_atom()

    if Map.has_key?(%UserInput{}, sender_address) && Map.has_key?(%UserInput{}, receiver_address) do
      amount = IO.gets("Enter amount to transfer --> ")
      amount = String.trim(amount) |> String.to_integer()
      sender_balance = Map.get(updated_input, sender_address)
      receiver_balance = Map.get(updated_input, receiver_address)

      if sender_balance >= amount do
        updated_input = Map.put(updated_input, sender_address, sender_balance - amount)
        updated_input = Map.put(updated_input, receiver_address, receiver_balance + amount)
        # IO.inspect updated_input
        IO.puts "Transaction completed, continue further...."
        chain = chain |> Blockchain.new_transaction(sender_address, receiver_address, amount)
        [chain, block_size] = check_block_creation(block_size-1, num_transaction, tgt, chain)
        main(updated_input, block_size, num_transaction - 1, tgt, chain)
      else
        IO.puts("Sender doesnt have enough bitcoins")
      end
    else
      IO.puts("Invalid sender or receiver address!")
    end
  end

  def check_block_creation(b_size, tran_left, tgt, chain) do
    node_a = GenServer.whereis(:a)
    [chain, block_size] =
      cond do
        b_size == 0 ->
          chain = GenServer.call node_a, {:mine, tgt, chain}, :infinity
          IO.puts("\n****** NEW BLOCK CREATED ********")
          IO.puts("****** BELOW IS THE UPDATED BLOCK CHAIN ********\n")
          IO.inspect(chain)
          [chain, 3]

        tran_left == 1 ->
          chain = GenServer.call node_a, {:mine, tgt, chain}, :infinity
          IO.puts("\n****** FINAL BLOCK CREATED ********")
          IO.puts("****** BELOW IS THE FINAL BLOCK CHAIN ********\n")
          IO.inspect(chain)
          [chain, 0]

        true ->
          [chain, b_size]
      end

    [chain, block_size]
  end

  # getOriginalBlockSize()

  def set_balance() do
    # Map.put(%TakeInput{}, s, sb-am)
    initial_input = %UserInput{
      a: 20,
      b: 0,
      c: 0,
      d: 0
      # e: 0
    }

    initial_input
  end
end
