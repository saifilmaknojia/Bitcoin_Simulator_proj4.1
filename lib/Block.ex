defmodule Block do
  defstruct [:previous_block_hash, :current_hash, :nonce, :current_transactions, :timestamp]

  def genesis do
    %Block{
      current_transactions: [],
      previous_block_hash: "THIS_IS_THE_GENESIS_BLOCK",
      timestamp: NaiveDateTime.utc_now() |> NaiveDateTime.to_string()
    }
  end

  def new(transactions, prev_hash) do
    block = %Block{
      current_transactions: transactions,
      previous_block_hash: prev_hash,
      timestamp: NaiveDateTime.utc_now()
    }

    proof_of_work = POW.new(block)
    {nonce, hash} = POW.calculate(proof_of_work)
    %{block | nonce: nonce, current_hash: hash}
  end
end
