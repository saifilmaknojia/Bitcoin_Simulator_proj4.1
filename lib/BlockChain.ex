defmodule Blockchain do
  defstruct [:chain, :current_transactions]

  def init do
    genesis_block = Block.genesis_block
      |> Block.put_block_hash

    %Blockchain {
      chain: [genesis_block],
      current_transactions: []
    }
  end

  def new_block %Blockchain{}=blockchain, tgt do
    prev_hash = hd(blockchain.chain).hash
    transactions = blockchain.current_transactions

    new_block = Block.new transactions, prev_hash, tgt

    %Blockchain {
      chain: [new_block | blockchain.chain],
      current_transactions: []
    }
  end

  def new_transaction %Blockchain{}=blockchain, sender, receiver, amount do
    #if transaction_is_valid sender, receiver, amount do
     # update_wallet sender, -amount
      # update_wallet receiver, amount

      %Blockchain {
        chain: blockchain.chain,
        current_transactions: [
          %Transaction {
            sender: sender,
            receiver: receiver,
            amount: amount
          } | blockchain.current_transactions
        ]
      }
   # else
      # IO.puts "Invalid transaction."
      # blockchain
   # end
  end

  def transaction_is_valid sender, receiver, amount do
    sender_pid = GenServer.whereis String.to_atom("#{sender}")
    receiver_pid = GenServer.whereis String.to_atom("#{receiver}")

    both_alive = not is_nil(sender_pid) and not is_nil(receiver_pid)
    sender_amount = GenServer.call sender_pid, :peek

    if both_alive and amount>=0 and sender_amount >= amount do
      true
    else
      false
    end
  end

  def update_wallet node, amount do
    GenServer.whereis(String.to_atom("#{node}"))
      |> GenServer.cast({:update_wallet, amount})
  end
end
