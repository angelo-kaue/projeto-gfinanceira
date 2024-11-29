defmodule Cfinanceiro.Finance do
  import Ecto.Query, warn: false
  alias Cfinanceiro.Repo

  alias Cfinanceiro.Finance.Despesa
  alias Cfinanceiro.Finance.Receita

  # Funções de Receita permanecem inalteradas.
  def list_receitas do
    Repo.all(Receita)
  end

  def get_receita!(id), do: Repo.get!(Receita, id)

  def create_receita(attrs \\ %{}) do
    %Receita{}
    |> Receita.changeset(attrs)
    |> Repo.insert()
  end

  def update_receita(%Receita{} = receita, attrs) do
    receita
    |> Receita.changeset(attrs)
    |> Repo.update()
  end

  def delete_receita(%Receita{} = receita) do
    Repo.delete(receita)
  end

  def change_receita(%Receita{} = receita, attrs \\ %{}) do
    Receita.changeset(receita, attrs)
  end

  # Alterações em despesas para suportar filtros
  def list_despesas(params \\ %{}) do
    query = from d in Despesa

    query =
      cond do
        params["filter_month"] ->
          from d in query,
            where: fragment("to_char(?, 'YYYY-MM') = ?", d.data, ^params["filter_month"])

        params["start_date"] && params["end_date"] ->
          from d in query,
            where: d.data >= ^Date.from_iso8601!(params["start_date"]) and d.data <= ^Date.from_iso8601!(params["end_date"])

        params["order"] == "desc" ->
          from d in query, order_by: [desc: d.valor]

        params["order"] == "asc" ->
          from d in query, order_by: [asc: d.valor]

        true ->
          query
      end

    Repo.all(query)
  end

  def get_despesa!(id), do: Repo.get!(Despesa, id)

  def create_despesa(attrs \\ %{}) do
    %Despesa{}
    |> Despesa.changeset(attrs)
    |> Repo.insert()
  end

  def update_despesa(%Despesa{} = despesa, attrs) do
    despesa
    |> Despesa.changeset(attrs)
    |> Repo.update()
  end

  def delete_despesa(%Despesa{} = despesa) do
    Repo.delete(despesa)
  end

  def change_despesa(%Despesa{} = despesa, attrs \\ %{}) do
    Despesa.changeset(despesa, attrs)
  end
end
