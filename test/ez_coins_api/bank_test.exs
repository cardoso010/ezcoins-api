defmodule EzCoinsApi.BankTest do
  use EzCoinsApi.DataCase

  alias EzCoinsApi.Bank
  alias EzCoinsApi.Accounts

  describe "donations" do
    alias EzCoinsApi.Bank.Donation

    @valid_attrs %{quantity: 42, reason: "some reason"}
    @update_attrs %{quantity: 43, reason: "some updated reason"}
    @invalid_attrs %{quantity: nil, reason: nil}

    @sender_attrs %{
      email: "sender@sender.com",
      password: "sender123",
      password_confirmation: "sender123"
    }
    @receiver_attrs %{
      email: "receiver@receiver.com",
      password: "receiver123",
      password_confirmation: "receiver123"
    }

    setup do
      {:ok, sender} = Accounts.create_user(@sender_attrs)
      {:ok, receiver} = Accounts.create_user(@receiver_attrs)
      {:ok, sender: sender.id, receiver: receiver.id}
    end

    def donation_fixture(attrs \\ %{}) do
      {:ok, donation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bank.create_donation()

      donation
    end

    test "list_donations/0 returns all donations",
         context do
      donation = donation_fixture(context)
      assert Bank.list_donations() == [donation]
    end

    test "get_donation!/1 returns the donation with given id", context do
      donation = donation_fixture(context)
      assert Bank.get_donation!(donation.id) == donation
    end

    test "create_donation/1 with valid data creates a donation", context do
      valid = context |> Enum.into(@valid_attrs)
      assert {:ok, %Donation{} = donation} = Bank.create_donation(valid)
      assert donation.quantity == 42
      assert donation.reason == "some reason"
      assert donation.sender == context.sender
      assert donation.receiver == context.receiver
    end

    test "create_donation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.create_donation(@invalid_attrs)
    end

    test "update_donation/2 with valid data updates the donation", context do
      donation = donation_fixture(context)
      assert {:ok, %Donation{} = donation} = Bank.update_donation(donation, @update_attrs)
      assert donation.quantity == 43
      assert donation.reason == "some updated reason"
    end

    test "update_donation/2 with invalid data returns error changeset", context do
      donation = donation_fixture(context)
      assert {:error, %Ecto.Changeset{}} = Bank.update_donation(donation, @invalid_attrs)
      assert donation == Bank.get_donation!(donation.id)
    end

    test "delete_donation/1 deletes the donation", context do
      donation = donation_fixture(context)
      assert {:ok, %Donation{}} = Bank.delete_donation(donation)
      assert_raise Ecto.NoResultsError, fn -> Bank.get_donation!(donation.id) end
    end

    test "change_donation/1 returns a donation changeset", context do
      donation = donation_fixture(context)
      assert %Ecto.Changeset{} = Bank.change_donation(donation)
    end
  end
end
