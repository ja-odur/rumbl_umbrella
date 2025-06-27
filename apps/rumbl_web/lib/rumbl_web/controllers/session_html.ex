defmodule RumblWeb.SessionHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `session_html` directory for all templates available.
  """
  use RumblWeb, :html

  embed_templates "session_html/*"
end