chain = Blockchain.init

# Initialize nodes, each with their own wallet
Node.start_link "1"
Node.start_link "2"
Node.start_link "3"
Node.start_link "4"

node1_pid = GenServer.whereis(:"1")
node2_pid = GenServer.whereis(:"2")
node3_pid = GenServer.whereis(:"3")
node4_pid = GenServer.whereis(:"4")

chain = GenServer.call node1_pid, {:mine, chain}, :infinity
IO.inspect chain
IO.puts "----------------------------------------------------------"

# Create transactions and place into new block
chain = Blockchain.new_transaction chain, "1", "3", 4
chain = Blockchain.new_transaction chain, "3", "2", 2
chain = Blockchain.new_transaction chain, "2", "4", 1
chain = GenServer.call node2_pid, {:mine, chain}, :infinity
IO.inspect chain
IO.puts "----------------------------------------------------------"

chain = Blockchain.new_transaction chain, "2", "1", 3
chain = Blockchain.new_transaction chain, "4", "2", 1
chain = GenServer.call node1_pid, {:mine, chain}, :infinity
IO.inspect chain
IO.puts "----------------------------------------------------------"


IO.puts "Number of coins held by each node:\n"
IO.puts "Node 1: #{inspect GenServer.call node1_pid, :peek}"
IO.puts "Node 2: #{inspect GenServer.call node2_pid, :peek}"
IO.puts "Node 3: #{inspect GenServer.call node3_pid, :peek}"
IO.puts "Node 4: #{inspect GenServer.call node4_pid, :peek}"
