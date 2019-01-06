defmodule Proj4Test do
  use ExUnit.Case
  doctest Proj4

  test "initialize blockchain" do
    chain = Blockchain.init
    chain_length = chain.chain |> length
    prev_hash = hd(chain.chain).prev_hash
    assert 1 = chain_length
    assert "GENESIS_BLOCK" = prev_hash
  end

  test "transactions do not occur when invalid" do
    chain = Blockchain.init
    Node.start_link "1"
    Node.start_link "2"
    node1_pid = GenServer.whereis(:"1")
    node2_pid = GenServer.whereis(:"2")

    # Assign Node1 10 coins
    GenServer.cast node1_pid, {:update_wallet, 10}

    # Node1 sends Node2 20 coins
    chain = Blockchain.new_transaction chain, "1", "2", 20

    assert Enum.empty? chain.current_transactions

    # Node1 has 10 coins, Node2 has 0 coins
    assert 10 = GenServer.call node1_pid, :peek
    assert 0  = GenServer.call node2_pid, :peek
  end

  test "transactions transfer coins when valid" do
    chain = Blockchain.init
    Node.start_link "1"
    Node.start_link "2"
    node1_pid = GenServer.whereis(:"1")
    node2_pid = GenServer.whereis(:"2")

    # Assign Node1 10 coins
    GenServer.cast node1_pid, {:update_wallet, 10}

    # Node1 sends Node2 10 coins
    chain = Blockchain.new_transaction chain, "1", "2", 10

    # Node1 has 0 coins, Node2 has 10 coins
    assert 0 = GenServer.call node1_pid, :peek
    assert 10  = GenServer.call node2_pid, :peek
  end

  test "mining calculates valid proof of work" do
  end

  test "mining appends current transactions to block" do
    chain = Blockchain.init
    Node.start_link "1"
    Node.start_link "2"
    node1_pid = GenServer.whereis(:"1")
    node2_pid = GenServer.whereis(:"2")

    # Node1 mines and receives 5 coins
    chain = GenServer.call node1_pid, {:mine, chain}, :infinity

    # Node1 sends Node2 5 coins
    chain = Blockchain.new_transaction chain, "1", "2", 5

    # Node1 mines again
    chain = GenServer.call node1_pid, {:mine, chain}, :infinity
    transaction = hd(chain.chain).transactions |> hd

    # Transaction recorded in previous block
    assert %Transaction {
      sender: "1",
      receiver: "2",
      amount: 5
    } = transaction
  end

  test "mining appends new block to blockchain" do
    chain = Blockchain.init
    chain = Blockchain.new_block chain

    assert 2 = length(chain.chain)
  end
end
