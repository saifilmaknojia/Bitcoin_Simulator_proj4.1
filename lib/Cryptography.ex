defmodule Cryptography do
  @fields_to_hash [:transactions, :previous_hash, :timestamp]

  def hash_internal(%{} = block) do
    block
    |> Map.take(@fields_to_hash)
    |> Poison.encode!()
    |> sha256

    # :crypto.hash(:sha256)
    # |> Base.encode16
  end

  def generate_and_enter_hash(%{} = block) do
    %{block | current_hash: hash_internal(block)}
  end

  # Calculate SHA256 for a binary string
  def sha256(binary) do
    :crypto.hash(:sha256, binary) |> Base.encode16()
  end
end
