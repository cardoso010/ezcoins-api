defmodule EzCoinsApi.AccountsTest do
  use EzCoinsApi.DataCase

  alias EzCoinsApi.Accounts

  describe "users" do
    alias EzCoinsApi.Accounts.User

    @valid_attrs %{
      email: "some@email.com",
      password: "some password_hash",
      password_confirmation: "some password_hash"
    }
    @update_attrs %{
      email: "some@updatedemail.com",
      password: "some updated password_hash",
      password_confirmation: "some updated password_hash"
    }
    @invalid_attrs %{email: nil, password: nil, password_confirmation: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    def reset_password_confirmation(user) do
      %User{user | password_confirmation: nil}
    end

    test "list_users/0 returns all users" do
      user = user_fixture() |> reset_password_confirmation()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture() |> reset_password_confirmation()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some@updatedemail.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      refute user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
