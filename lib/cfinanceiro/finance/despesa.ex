defmodule Cfinanceiro.Finance.Despesa do
  use Ecto.Schema
  import Ecto.Changeset

  schema "despesas" do
    field :data, :date
    field :descricao, :string
    field :valor, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(despesa, attrs) do
    despesa
    |> cast(attrs, [:descricao, :valor, :data])
    |> validate_required([:descricao, :valor, :data])
  end
end
