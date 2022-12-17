defmodule Tell1storyWeb.Token do
  @namespace "user salt"

  def sign(data) do
    Phoenix.Token.sign(Tell1storyWeb.Endpoint, @namespace, data)
  end

  def verify(token) do
    Phoenix.Token.verify(Tell1storyWeb.Endpoint, @namespace, token, max_age: 5 * 24 * 3600)
  end
end
