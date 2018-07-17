defmodule Feud.Questions.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  alias Feud.Questions.Answer

  schema "votes" do
    field(:user_id, :integer)
    belongs_to(:answer, Answer)

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:answer_id, :user_id])
    |> validate_required([:user_id])
  end
end
