defmodule RumblWeb.UserJSON do
  alias Rumbl.Accounts

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

  def show(%Accounts.User{} = user) do
    %{
      id: user.id,
      username: user.username
    }
  end
end
