chain = Blockchain.init

# Initialize nodes, each with their own wallet
Node.start_link "a"
Node.start_link "b"
Node.start_link "c"
Node.start_link "d"

initial_transaction = UserInput.set_balance()
[target_mani, num_transaction] = System.argv
# POW.set_target_manipulator(target_mani)
target_manipulator = String.to_integer(target_mani)
num_transaction = String.to_integer(num_transaction)
UserInput.main(initial_transaction, 3, num_transaction, target_manipulator, chain)
