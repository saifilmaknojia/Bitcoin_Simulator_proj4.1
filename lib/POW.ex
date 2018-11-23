defmodule POW do
  use Bitwise, only_operators: true
  defstruct [:target_value, :block_input]

  @target_manipulator 17
  # @upper_limit 576460752303423488
  @upper_limit 45_213_647_895_483_217

  def new(block) do
    left_shift = 1 <<< (256 - @target_manipulator)
    # IO.puts "Target ---> #{left_shift}"
    %POW{
      block_input: block,
      target_value: left_shift
    }
  end

  def calculate(%POW{} = work_on) do
    IO.puts(
      "Working on MINING BLOCK with given transactions --> #{
        inspect(work_on.block_input.current_transactions)
      }"
    )

    find_appropriate_nonce(work_on, 0)
  end

  def find_appropriate_nonce(%POW{} = pow, nonce) when nonce < @upper_limit do
    data = POW.data_to_Binary(pow, nonce)
    hash = data |> Cryptography.sha256()
    {hash_int, _} = hash |> Integer.parse(16)

    if hash_int > pow.target_value do
      find_appropriate_nonce(pow, nonce + 1)
    else
      {nonce, hash}
    end
  end

  def data_to_Binary(%POW{} = proof_of_work, nonce) do
    prev_hash = get_previous_blocks_hash(proof_of_work)
    transactions = get_transactions_from_block(proof_of_work)
    transactions = transactions |> Poison.encode!()
    timestamp = get_timestamp(proof_of_work)
    target_manipulator = get_target_manipulator()
    # nonce = get_nonce()
    <<
      # previous_hash_to_binary(proof_of_work),
      prev_hash::binary,
      # proof_of_work.block_input.current_transactions |> Poison.encode!::binary,
      transactions::binary,
      # proof_of_work.block_input.timestamp |> to_string::binary,
      timestamp::binary,
      # Integer.to_string(@target_manipulator, 16)::binary,
      target_manipulator::binary,
      Integer.to_string(nonce, 16)::binary
    >>
  end

  def get_previous_blocks_hash(%POW{} = proof_of_work) do
    # IO.puts "Calculating prev block to binary"
    proof_of_work.block_input.previous_block_hash
  end

  def get_transactions_from_block(%POW{} = proof_of_work) do
    # IO.puts "Calculating prev block to binary"
    proof_of_work.block_input.current_transactions
  end

  def get_timestamp(%POW{} = proof_of_work) do
    # IO.puts "Calculating prev block to binary"
    proof_of_work.block_input.timestamp |> to_string
  end

  def get_target_manipulator do
    Integer.to_string(@target_manipulator, 16)
  end
end
