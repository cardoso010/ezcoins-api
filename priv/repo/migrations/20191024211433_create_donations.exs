defmodule EzCoinsApi.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :quantity, :integer
      add :reason, :string
      add :sender, references(:users, on_delete: :nothing)
      add :receiver, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:donations, [:sender])
    create index(:donations, [:receiver])
  end
end
