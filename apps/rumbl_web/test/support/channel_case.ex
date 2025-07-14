defmodule RumblWeb.ChannelCase do
	@moduledoc """
  This module defines the test case to be used by channel tests.

  Such tests rely on `Phoenix.ChannelTest` and also import other
  functionality to make it easier to build common data structures
  and query the data layer.

  Finally, if the test case interacts with the database, it cannot
  be async.  For this reason, every test runs inside a transaction
  which is reset at the beginning of the test unless the test case is
  marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels.
      import Phoenix.ChannelTest

      # The default endpoint for testing
      @endpoint RumblWeb.Endpoint
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Rumbl.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)

    on_exit(fn ->
      :timer.sleep(200)

      for pid <- RumblWeb.Presence.fetchers_pids() do
        ref = Process.monitor(pid)
        assert_receive {:DOWN, ^ref, _, _, _}, 1000
      end
    end)

    :ok
  end
end
