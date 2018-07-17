defmodule FeudWeb.VoteView do
  use FeudWeb, :view
  alias FeudWeb.VoteView
  alias FeudWeb.AnswerView

  def render("index.json", %{votes: votes}) do
    %{data: render_many(votes, VoteView, "vote_id.json")}
  end

  def render("show.json", %{answer: answer}) do
    AnswerView.render("show.json", %{answer: answer})
  end

  def render("show.json", %{vote: vote}) do
    %{data: render_one(vote, VoteView, "vote.json")}
  end

  def render("vote.json", %{vote: vote}) do
    %{id: vote.id, user_id: vote.user_id}
  end

  def render("vote_id.json", %{vote: vote}) do
    vote.id
  end
end
