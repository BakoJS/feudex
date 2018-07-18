defmodule FeudWeb.AnswerController do
  use FeudWeb, :controller

  alias Feud.Questions
  alias Feud.Questions.Answer

  action_fallback(FeudWeb.FallbackController)

  def index(conn, _params) do
    answers = Questions.list_answers()
    render(conn, "index.json", answers: answers)
  end

  def create(conn, %{"answer" => answer_params}) do
    with {:ok, %Answer{} = answer} <- Questions.create_answer(answer_params) do
      conn
      |> put_status(:created)
      |> render("show.json", answer: answer)
    end
  end

  def show(conn, %{"id" => id}) do
    answer = Questions.get_answer!(id)
    render(conn, "show.json", answer: answer)
  end

  def update(conn, %{"id" => id, "answer" => answer_params}) do
    answer = Questions.get_answer!(id)

    with {:ok, %Answer{} = answer} <- Questions.update_answer(answer, answer_params) do
      render(conn, "show.json", answer: answer)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = Questions.get_answer!(id)

    with {:ok, %Answer{}} <- Questions.delete_answer(answer) do
      send_resp(conn, :no_content, "")
    end
  end
end
