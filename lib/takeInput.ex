defmodule TakeInput do
  defstruct [:a, :b, :c, :d, :e]

  def retake(updated_input, block_size, num_transaction, chain) do
    # track = %TakeInput{}
    # IO.inspect %TakeInput{}
    sender_address = IO.gets("Enter sender's address --> ")
    sender_address = String.trim(sender_address) |> String.to_atom()
    receiver_address = IO.gets("Enter receiver's address --> ")
    receiver_address = String.trim(receiver_address) |> String.to_atom()

    if Map.has_key?(%TakeInput{}, sender_address) && Map.has_key?(%TakeInput{}, receiver_address) do
      amount = IO.gets("Enter amount to transfer --> ")
      amount = String.trim(amount) |> String.to_integer()
      sender_balance = Map.get(updated_input, sender_address)
      receiver_balance = Map.get(updated_input, receiver_address)

      if sender_balance >= amount do
        updated_input = Map.put(updated_input, sender_address, sender_balance - amount)
        updated_input = Map.put(updated_input, receiver_address, receiver_balance + amount)
        # IO.inspect updated_input
        IO.puts "Transaction completed, continue further...."
        chain = chain |> BlockChain.new_transaction(sender_address, receiver_address, amount)
        [chain, block_size] = check_block_creation(block_size-1, num_transaction, chain)

        #  IO.puts "Type of Block = #{is_integer(block_size)}"
        # IO.puts "Blocks = #{block_size}"
        # IO.puts "AFTER CHAIN == #{inspect chain}"
        # [chain, block_size] = check_block_creation(block_size, num_transaction, chain)

        # chain = cond do
        # block_size
        # end
        # orignalBlockSize = block_size+1
        # IO.puts "Final chain ----> #{inspect chain}"
        Entry.main(updated_input, block_size, num_transaction - 1, chain)
      else
        IO.puts("Sender doesnt have enough bitcoins")
      end
    else
      IO.puts("Invalid sender or receiver address!")
    end
  end

  def check_block_creation(b_size, tran_left, chain) do
    [chain, block_size] =
      cond do
        b_size == 0 ->
          chain = chain |> BlockChain.generate_new_Block()
          IO.puts("****** NEW BLOCK CREATED ********")
          IO.inspect(chain)
          [chain, 3]

        tran_left == 1 ->
          chain = chain |> BlockChain.generate_new_Block()
          IO.puts("****** FINAL BLOCK CHAIN ********")
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
    initial_input = %TakeInput{
      a: 20,
      b: 0,
      c: 0,
      d: 0,
      e: 0
    }

    initial_input
  end
end
