defmodule CfinanceiroWeb.Router do
  use CfinanceiroWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CfinanceiroWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CfinanceiroWeb do
  pipe_through :browser

  get "/", PageController, :home

  resources "/despesas", DespesaController, only: [:index, :create, :update, :delete]
  resources "/receitas", ReceitaController, only: [:index, :create, :update, :delete]
end

scope "/", CfinanceiroWeb do
  pipe_through :browser

  get "/", PageController, :index
  resources "/receitas", ReceitaController
  resources "/despesas", DespesaController
end


scope "/", CfinanceiroWeb do
  pipe_through :browser

  get "/receitas", ReceitaController, :index
  get "/despesas", DespesaController, :index
end


  # Other scopes may use custom stacks.
  # scope "/api", CfinanceiroWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:cfinanceiro, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CfinanceiroWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
