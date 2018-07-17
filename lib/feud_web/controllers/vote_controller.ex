defmodule FeudWeb.VoteController do
  use FeudWeb, :controller

  alias Feud.Questions

  action_fallback(FeudWeb.FallbackController)

  def index(conn, params) do
    votes = Questions.list_votes_for_user(params["user_id"])
    render(conn, "index.json", votes: votes)
  end

  def create(conn, %{"vote" => vote_params}) do
    with {:ok, answer} <- Questions.create_vote(vote_params) do
      conn
      |> put_status(:created)
      |> render("show.json", answer: answer)
    end
  end

  def delete(conn, %{"vote" => vote_params}) do
    IO.inspect(vote_params)
    vote = Questions.get_vote!(vote_params["answer_id"], vote_params["user_id"])

    IO.inspect(vote)

    with {:ok, answer} <- Questions.delete_vote(vote) do
      conn |> render("show.json", answer: answer)
    end
  end
end
