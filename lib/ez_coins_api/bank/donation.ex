defmodule EzCoinsApi.Bank.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field :quantity, :integer
    field :reason, :string
    field :sender, :id
    field :receiver, :id

    timestamps()
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:quantity, :reason, :sender, :receiver])
    |> validate_required([:quantity, :reason, :sender, :receiver])
    |> validate_number(:quantity, greater_than: 0)
    |> validate_length(:reason, min: 5)
  end
end
