defmodule Feud.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add(:text, :text)
      add(:vote_count, :integer)
      add(:delete_date, :naive_datetime)
      add(:user_id, :integer)
      add(:question_id, references(:questions, on_delete: :nothing))

      timestamps()
    end

    create(index(:answers, [:question_id]))
    create(index(:answers, [:user_id]))
  end
end
