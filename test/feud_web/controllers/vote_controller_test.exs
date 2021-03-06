defmodule FeudWeb.VoteControllerTest do
  use FeudWeb.ConnCase

  alias Feud.Questions
  alias Feud.Questions.Vote

  @create_attrs %{user_id: 42}
  @update_attrs %{user_id: 43}
  @invalid_attrs %{user_id: nil}

  def fixture(:vote) do
    {:ok, vote} = Questions.create_vote(@create_attrs)
    vote
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all votes", %{conn: conn} do
      conn = get(conn, vote_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create vote" do
    test "renders vote when data is valid", %{conn: conn} do
      conn = post(conn, vote_path(conn, :create), vote: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, vote_path(conn, :show, id))
      assert json_response(conn, 200)["data"] == %{"id" => id, "user_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, vote_path(conn, :create), vote: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update vote" do
    setup [:create_vote]

    test "renders vote when data is valid", %{conn: conn, vote: %Vote{id: id} = vote} do
      conn = put(conn, vote_path(conn, :update, vote), vote: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, vote_path(conn, :show, id))
      assert json_response(conn, 200)["data"] == %{"id" => id, "user_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, vote: vote} do
      conn = put(conn, vote_path(conn, :update, vote), vote: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete vote" do
    setup [:create_vote]

    test "deletes chosen vote", %{conn: conn, vote: vote} do
      conn = delete(conn, vote_path(conn, :delete, vote))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, vote_path(conn, :show, vote))
      end)
    end
  end

  defp create_vote(_) do
    vote = fixture(:vote)
    {:ok, vote: vote}
  end
end
