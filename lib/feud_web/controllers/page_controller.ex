defmodule FeudWeb.PageController do
  use FeudWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
