defmodule Cfinanceiro.Finance.Receita do
  use Ecto.Schema
  import Ecto.Changeset

  schema "receitas" do
    field :data, :date
    field :descricao, :string
    field :valor, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(receita, attrs) do
    receita
    |> cast(attrs, [:descricao, :valor, :data])
    |> validate_required([:descricao, :valor, :data])
  end
end
