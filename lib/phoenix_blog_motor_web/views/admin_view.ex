defmodule PhoenixBlogMotorWeb.AdminView do
  use PhoenixBlogMotorWeb, :view

  def render("status.json", %{}) do
    %{data: "ok"}
  end
end
