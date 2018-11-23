defmodule BlockChain do
  defstruct [:finalchain, :finalTransactions]
  def genesis do
    %BlockChain
    {
      finalchain: [Cryptography.generate_and_enter_hash(Block.genesis)],
      finalTransactions: []
    }
  end


  def new_transaction %BlockChain{}=blockchain, sender, receiver, amount do
    # transaction = %Transactions {
    #  sender: sender,
    # receiver: receiver,
    #  amount: amount
    # }
    %BlockChain {
      finalchain: blockchain.finalchain,
      finalTransactions: [
        %Transactions {
         sender: sender,
         receiver: receiver,
         amount: amount
        } |blockchain.finalTransactions]
    }
  end

  def generate_new_Block %BlockChain{}=blockchain do
      %Block{current_hash: prev} = hd(blockchain.finalchain)
      block = blockchain.finalTransactions |> Block.new(prev)
      %BlockChain {
        finalchain: [block | blockchain.finalchain],
        finalTransactions: []
      }
  end
end
