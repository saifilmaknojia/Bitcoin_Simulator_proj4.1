defmodule Transactions do
  defstruct [:sender, :receiver, :amount]

  def new_transaction(sndr, rcvr, amt) do
    %Transactions{
      sender: sndr,
      receiver: rcvr,
      amount: amt
    }
  end
end
