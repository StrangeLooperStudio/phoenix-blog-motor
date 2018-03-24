defmodule PhoenixBlogMotorWeb.ErrorViewTest do
  use PhoenixBlogMotorWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json-api" do
    assert render(PhoenixBlogMotorWeb.ErrorView, "404.json-api", []) ==
           %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.json-api" do
    assert render(PhoenixBlogMotorWeb.ErrorView, "500.json-api", []) ==
           %{errors: %{detail: "Internal Server Error"}}
  end
end
