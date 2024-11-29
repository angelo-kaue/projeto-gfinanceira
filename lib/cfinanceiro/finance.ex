defmodule Cfinanceiro.Finance do
  import Ecto.Query, warn: false
  alias Cfinanceiro.Repo

  alias Cfinanceiro.Finance.Despesa

  # Lista despesas com filtros e ordenações
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

    # Ordenação
    query =
      case params["order"] do
        "desc" -> from d in query, order_by: [desc: d.valor]
        "asc" -> from d in query, order_by: [asc: d.valor]
        _ -> query
      end

    Repo.all(query)
  end

  defp valid_date?(nil), do: false
  defp valid_date?(""), do: false
  defp valid_date?(date) do
    case Date.from_iso8601(date) do
      {:ok, _date} -> true
      _ -> false
    end
  end

  # Função para criar ou alterar um changeset
  def change_despesa(%Despesa{} = despesa, attrs \\ %{}) do
    Despesa.changeset(despesa, attrs)
  end

  # Cria uma despesa
  def create_despesa(attrs \\ %{}) do
    %Despesa{}
    |> change_despesa(attrs)
    |> Repo.insert()
  end

  # Retorna uma despesa pelo ID ou lança erro se não encontrar
  def get_despesa!(id), do: Repo.get!(Despesa, id)

  # Atualiza uma despesa
  def update_despesa(%Despesa{} = despesa, attrs) do
    despesa
    |> change_despesa(attrs)
    |> Repo.update()
  end

  # Exclui uma despesa
  def delete_despesa(%Despesa{} = despesa) do
    Repo.delete(despesa)
  end
end
