defmodule FeudWeb.Router do
  use FeudWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", FeudWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  scope "/api", FeudWeb do
    pipe_through(:api)
    resources("/questions", QuestionController, except: [:new, :edit])
    resources("/answers", AnswerController, except: [:new, :edit])
    post("/unvote", VoteController, :delete)
    post("/vote", VoteController, :create)
    post("/votes", VoteController, :index)
  end
end
