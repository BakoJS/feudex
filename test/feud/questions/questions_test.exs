defmodule Feud.QuestionsTest do
  use Feud.DataCase

  alias Feud.Questions

  describe "questions" do
    alias Feud.Questions.Question

    @valid_attrs %{delete_date: ~N[2010-04-17 14:00:00.000000], text: "some text", user_id: 42}
    @update_attrs %{
      delete_date: ~N[2011-05-18 15:01:01.000000],
      text: "some updated text",
      user_id: 43
    }
    @invalid_attrs %{delete_date: nil, text: nil, user_id: nil}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Questions.create_question()

      question
    end

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Questions.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Questions.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Questions.create_question(@valid_attrs)
      assert question.delete_date == ~N[2010-04-17 14:00:00.000000]
      assert question.text == "some text"
      assert question.user_id == 42
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, question} = Questions.update_question(question, @update_attrs)
      assert %Question{} = question
      assert question.delete_date == ~N[2011-05-18 15:01:01.000000]
      assert question.text == "some updated text"
      assert question.user_id == 43
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_question(question, @invalid_attrs)
      assert question == Questions.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Questions.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Questions.change_question(question)
    end
  end
end
