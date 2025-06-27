defmodule RumblWeb.AnnotationJSON do
  alias Rumbl.Multimedia
  alias RumblWeb.UserJSON

  def annotations(annotations) do
    Enum.map(annotations, &show(&1))
  end
  
  def show(%Multimedia.Annotation{} = annotation) do
    %{
      id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: UserJSON.show(annotation.user)
    }
  end
end
