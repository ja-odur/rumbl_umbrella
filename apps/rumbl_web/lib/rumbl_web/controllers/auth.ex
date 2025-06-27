defmodule RumblWeb.Auth do
  import Phoenix.Controller
  import Plug.Conn

  # Duplicated the import from rumbl_web.ex into here to avoid a circular
  # dependency between this module and rumbl_web.
  # This import is needed to use the new ~p syntax for saying routes.
  use Phoenix.VerifiedRoutes,
    endpoint: RumblWeb.Endpoint,
    router: RumblWeb.Router,
    statics: RumblWeb.static_paths()


  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] -> 
        put_current_user(conn, user)

      user = user_id && Rumbl.Accounts.get_user(user_id) -> 
        put_current_user(conn, user)

      true -> assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
  
  defp put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)
    
    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end
end
