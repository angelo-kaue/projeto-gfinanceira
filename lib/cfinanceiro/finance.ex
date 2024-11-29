defmodule Cfinanceiro.Finance do
  import Ecto.Query, warn: false
  alias Cfinanceiro.Repo

  alias Cfinanceiro.Finance.Receita
  alias Cfinanceiro.Finance.Despesa  # Não remover a funcionalidade de Despesas!

  # Função para listar receitas (já existente)
  def list_receitas(params \\ %{}) do
    query = from r in Receita

    # Filtro por mês
    query =
      if params["filter_month"] && params["filter_month"] != "" do
        from r in query,
          where: fragment("to_char(?, 'YYYY-MM') = ?", r.data, ^params["filter_month"])
      else
        query
      end

    # Filtro por período
    query =
      if valid_date?(params["start_date"]) and valid_date?(params["end_date"]) do
        from r in query,
          where: r.data >= ^Date.from_iso8601!(params["start_date"]) and
                 r.data <= ^Date.from_iso8601!(params["end_date"])
      else
        query
      end

    # Ordenação por valores
    query =
      case params["order"] do
        "desc" -> from r in query, order_by: [desc: r.valor]
        "asc" -> from r in query, order_by: [asc: r.valor]
        _ -> query
      end

    Repo.all(query)
  end

  # Função para listar despesas
  def list_despesas(params \\ %{}) do
    query = from d in Despesa

    # Filtro por mês
    query =
      if params["filter_month"] && params["filter_month"] != "" do
        from d in query,
          where: fragment("to_char(?, 'YYYY-MM') = ?", d.data, ^params["filter_month"])
      else
        query
      end

    # Filtro por período
    query =
      if valid_date?(params["start_date"]) and valid_date?(params["end_date"]) do
        from d in query,
          where: d.data >= ^Date.from_iso8601!(params["start_date"]) and
                 d.data <= ^Date.from_iso8601!(params["end_date"])
      else
        query
      end

    # Ordenação por valores
    query =
      case params["order"] do
        "desc" -> from d in query, order_by: [desc: d.valor]
        "asc" -> from d in query, order_by: [asc: d.valor]
        _ -> query
      end

    Repo.all(query)
  end

  # Funções de alteração, criação, obtenção, atualização e exclusão de receitas (não modificadas)
  def change_receita(%Receita{} = receita, attrs \\ %{}) do
    Receita.changeset(receita, attrs)
  end

  def create_receita(attrs) do
    %Receita{}
    |> Receita.changeset(attrs)
    |> Repo.insert()
  end

  def get_receita!(id), do: Repo.get!(Receita, id)

  def update_receita(%Receita{} = receita, attrs) do
    receita
    |> Receita.changeset(attrs)
    |> Repo.update()
  end

  def delete_receita(%Receita{} = receita) do
    Repo.delete(receita)
  end

  # Funções para despesas (mantenha as mesmas)
  def change_despesa(%Despesa{} = despesa, attrs \\ %{}) do
    Despesa.changeset(despesa, attrs)
  end

  def create_despesa(attrs) do
    %Despesa{}
    |> Despesa.changeset(attrs)
    |> Repo.insert()
  end

  def get_despesa!(id), do: Repo.get!(Despesa, id)

  def update_despesa(%Despesa{} = despesa, attrs) do
    despesa
    |> Despesa.changeset(attrs)
    |> Repo.update()
  end

  def delete_despesa(%Despesa{} = despesa) do
    Repo.delete(despesa)
  end

  # Função para verificar data válida
  defp valid_date?(nil), do: false
  defp valid_date?(""), do: false
  defp valid_date?(date) do
    case Date.from_iso8601(date) do
      {:ok, _date} -> true
      _ -> false
    end
  end
end
