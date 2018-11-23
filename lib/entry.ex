defmodule Entry do
  def main(wallet, block_size, num_transaction, dc) do
    # IO.inspect args
    # [, block_size]=args
    #IO.inspect wallet
    # IO.inspect dc
    if num_transaction>0 do
      TakeInput.retake(wallet, block_size, num_transaction, dc)
    else
      IO.puts "Performed all transactions"
      IO.inspect wallet
      exit(:normal)
    end

   # System.argv()
  end
end
