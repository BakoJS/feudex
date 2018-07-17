defmodule Feud.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :user_id, :integer
      add :answer_id, references(:answers, on_delete: :nothing)

      timestamps()
    end

    create index(:votes, [:answer_id])
  end
end
