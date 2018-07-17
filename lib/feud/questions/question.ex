defmodule Feud.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias Feud.Questions.Answer

  schema "questions" do
    field(:delete_date, :naive_datetime)
    field(:text, :string)
    field(:user_id, :integer)
    has_many(:answers, Answer)

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text, :delete_date, :user_id])
    |> validate_required([:text, :user_id])
  end
end
