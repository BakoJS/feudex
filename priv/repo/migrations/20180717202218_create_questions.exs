defmodule Feud.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add(:text, :text)
      add(:delete_date, :naive_datetime)
      add(:user_id, :integer)

      timestamps()
    end

    create(index(:questions, [:user_id]))
  end
end
