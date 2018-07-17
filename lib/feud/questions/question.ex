defmodule Feud.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field(:delete_date, :naive_datetime)
    field(:text, :string)
    field(:user_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text, :delete_date, :user_id])
    |> validate_required([:text, :delete_date, :user_id])
  end
end
