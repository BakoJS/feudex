defmodule FeudWeb.QuestionControllerTest do
  use FeudWeb.ConnCase

  alias Feud.Questions
  alias Feud.Questions.Question

  @create_attrs %{delete_date: ~N[2010-04-17 14:00:00.000000], text: "some text", user_id: 42}
  @update_attrs %{
    delete_date: ~N[2011-05-18 15:01:01.000000],
    text: "some updated text",
    user_id: 43
  }
  @invalid_attrs %{delete_date: nil, text: nil, user_id: nil}

  def fixture(:question) do
    {:ok, question} = Questions.create_question(@create_attrs)
    question
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all questions", %{conn: conn} do
      conn = get(conn, question_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create question" do
    test "renders question when data is valid", %{conn: conn} do
      conn = post(conn, question_path(conn, :create), question: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, question_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "delete_date" => ~N[2010-04-17 14:00:00.000000],
               "text" => "some text",
               "user_id" => 42
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, question_path(conn, :create), question: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update question" do
    setup [:create_question]

    test "renders question when data is valid", %{
      conn: conn,
      question: %Question{id: id} = question
    } do
      conn = put(conn, question_path(conn, :update, question), question: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, question_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "delete_date" => ~N[2011-05-18 15:01:01.000000],
               "text" => "some updated text",
               "user_id" => 43
             }
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn = put(conn, question_path(conn, :update, question), question: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete question" do
    setup [:create_question]

    test "deletes chosen question", %{conn: conn, question: question} do
      conn = delete(conn, question_path(conn, :delete, question))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, question_path(conn, :show, question))
      end)
    end
  end

  defp create_question(_) do
    question = fixture(:question)
    {:ok, question: question}
  end
end
