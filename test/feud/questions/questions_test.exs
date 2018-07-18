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

  describe "answers" do
    alias Feud.Questions.Answer

    @valid_attrs %{
      delete_date: ~N[2010-04-17 14:00:00.000000],
      text: "some text",
      user_id: 42,
      votes: 42
    }
    @update_attrs %{
      delete_date: ~N[2011-05-18 15:01:01.000000],
      text: "some updated text",
      user_id: 43,
      votes: 43
    }
    @invalid_attrs %{delete_date: nil, text: nil, user_id: nil, votes: nil}

    def answer_fixture(attrs \\ %{}) do
      {:ok, answer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Questions.create_answer()

      answer
    end

    test "list_answers/0 returns all answers" do
      answer = answer_fixture()
      assert Questions.list_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Questions.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      assert {:ok, %Answer{} = answer} = Questions.create_answer(@valid_attrs)
      assert answer.delete_date == ~N[2010-04-17 14:00:00.000000]
      assert answer.text == "some text"
      assert answer.user_id == 42
      assert answer.votes == 42
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      assert {:ok, answer} = Questions.update_answer(answer, @update_attrs)
      assert %Answer{} = answer
      assert answer.delete_date == ~N[2011-05-18 15:01:01.000000]
      assert answer.text == "some updated text"
      assert answer.user_id == 43
      assert answer.votes == 43
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_answer(answer, @invalid_attrs)
      assert answer == Questions.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Questions.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Questions.change_answer(answer)
    end
  end

  describe "votes" do
    alias Feud.Questions.Vote

    @valid_attrs %{user_id: 42}
    @update_attrs %{user_id: 43}
    @invalid_attrs %{user_id: nil}

    def vote_fixture(attrs \\ %{}) do
      {:ok, vote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Questions.create_vote()

      vote
    end

    test "list_votes/0 returns all votes" do
      vote = vote_fixture()
      assert Questions.list_votes() == [vote]
    end

    test "get_vote!/1 returns the vote with given id" do
      vote = vote_fixture()
      assert Questions.get_vote!(vote.id) == vote
    end

    test "create_vote/1 with valid data creates a vote" do
      assert {:ok, %Vote{} = vote} = Questions.create_vote(@valid_attrs)
      assert vote.user_id == 42
    end

    test "create_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_vote(@invalid_attrs)
    end

    test "update_vote/2 with valid data updates the vote" do
      vote = vote_fixture()
      assert {:ok, vote} = Questions.update_vote(vote, @update_attrs)
      assert %Vote{} = vote
      assert vote.user_id == 43
    end

    test "update_vote/2 with invalid data returns error changeset" do
      vote = vote_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_vote(vote, @invalid_attrs)
      assert vote == Questions.get_vote!(vote.id)
    end

    test "delete_vote/1 deletes the vote" do
      vote = vote_fixture()
      assert {:ok, %Vote{}} = Questions.delete_vote(vote)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_vote!(vote.id) end
    end

    test "change_vote/1 returns a vote changeset" do
      vote = vote_fixture()
      assert %Ecto.Changeset{} = Questions.change_vote(vote)
    end
  end
end
