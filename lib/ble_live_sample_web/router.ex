defmodule BleLiveSampleWeb.Router do
  use BleLiveSampleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash # add ble sample
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {BleLiveSampleWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BleLiveSampleWeb do
    pipe_through :browser

    # get "/", PageController, :index
    # ble sample, replace root folder's contents
    live("/", BleSampleLive)
  end

  # Other scopes may use custom stacks.
  # scope "/api", BleLiveSampleWeb do
  #   pipe_through :api
  # end
end
