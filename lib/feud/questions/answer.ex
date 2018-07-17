defmodule Feud.Questions.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field(:delete_date, :naive_datetime)
    field(:text, :string)
    field(:user_id, :integer)
    field(:vote_count, :integer, default: 1)
    field(:question_id, :id)

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:text, :vote_count, :delete_date, :question_id, :user_id])
    |> validate_required([:text, :user_id])
  end
end
