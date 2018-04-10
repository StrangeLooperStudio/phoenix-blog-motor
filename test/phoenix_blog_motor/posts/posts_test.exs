defmodule PhoenixBlogMotor.PostsTest do
  use PhoenixBlogMotor.DataCase

  alias PhoenixBlogMotor.Posts

  describe "posts" do
    alias PhoenixBlogMotor.Posts.Post

    @valid_attrs %{
      title: "test",
      body: "test test"
    }
    @update_attrs %{
      body: "test2"
    }
    @invalid_attrs %{
      title: "",
      body: ""
    }

    def post_fixture(attrs \\ %{}) do
      {_code, post} =
        attrs
        |> Enum.into(attrs)
        |> Posts.create_post()
      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture(@valid_attrs)
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture(@valid_attrs)
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{}} = Posts.create_post(@valid_attrs)
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture(@valid_attrs)
      assert {:ok, post} = Posts.update_post(post, @update_attrs)
      assert %Post{} = post
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture(@valid_attrs)
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture(@valid_attrs)
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
