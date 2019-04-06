defmodule BleLiveSampleWeb.PageController do
  use BleLiveSampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
