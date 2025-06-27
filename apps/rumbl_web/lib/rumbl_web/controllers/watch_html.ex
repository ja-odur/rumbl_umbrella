defmodule RumblWeb.WatchHTML do
	use RumblWeb, :html

  alias Rumbl.Multimedia

  embed_templates "watch_html/*"

  def video(assigns) do
    # Assigns should be a Multimedia.Video
    ~H"""
    <.header>
      <%= @video.title %>
    </.header>
    <div id="video" data-id={@video.id} data-player-id={player_id(@video)}>
    </div>
    """
  end

  def player_id(video) do
    parsed_uri = URI.parse(video.url)
    query_params = URI.decode_query(parsed_uri.query)
    Map.get(query_params, "v")
  end
end
