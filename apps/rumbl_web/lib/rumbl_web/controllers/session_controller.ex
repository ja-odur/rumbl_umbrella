defmodule RumblWeb.SessionController do
  use RumblWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html", conn: conn)
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Rumbl.Accounts.authenticate_by_username_and_pass(username, password) do
      {:ok, user} ->
        conn
        |> RumblWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back, #{user.name}!")
        |> redirect(to: ~p"/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render(:new)
    end
  end
  
  def delete(conn, _params) do
    conn
    |> RumblWeb.Auth.logout()
    |> redirect(to: ~p"/")
  end
end
