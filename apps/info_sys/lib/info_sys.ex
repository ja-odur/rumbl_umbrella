defmodule InfoSys do
  @backends [InfoSys.Wolfam]

  defmodule Result do
    defstruct score: 0, text: nil, backend: nil
  end

  def compute(query, opts \\ []) do
    opts = Keyword.put_new(opts, :limit, 10)
    backends = opts[:backends] || @backends

    backends
    |> Enum.map(&sync_query(&1, query, opts))
  end

  defp sync_query(backend, query, opts) do
    Task.Supervisor.async_nolink(
      InfoSys.TaskSupervisor,
      backend,
      :compute,
      [query, opts],
      shutdown: :brutal_kill
    )
  end
end
