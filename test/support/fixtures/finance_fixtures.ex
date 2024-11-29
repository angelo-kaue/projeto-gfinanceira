defmodule Cfinanceiro.FinanceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cfinanceiro.Finance` context.
  """

  @doc """
  Generate a receita.
  """
  def receita_fixture(attrs \\ %{}) do
    {:ok, receita} =
      attrs
      |> Enum.into(%{
        data: ~D[2024-11-27],
        descricao: "some descricao",
        valor: "120.5"
      })
      |> Cfinanceiro.Finance.create_receita()

    receita
  end

  @doc """
  Generate a despesa.
  """
  def despesa_fixture(attrs \\ %{}) do
    {:ok, despesa} =
      attrs
      |> Enum.into(%{
        data: ~D[2024-11-27],
        descricao: "some descricao",
        valor: "120.5"
      })
      |> Cfinanceiro.Finance.create_despesa()

    despesa
  end
end
