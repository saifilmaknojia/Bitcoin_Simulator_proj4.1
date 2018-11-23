dynamicChain = BlockChain.genesis
# IO.inspect dynamicChain
initial_transaction = TakeInput.set_balance()
[num_transaction] = System.argv
num_transaction = String.to_integer(num_transaction)
Entry.main(initial_transaction, 3, num_transaction, dynamicChain)
