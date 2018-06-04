defmodule Lick do
  @data_directory Application.get_env(:lick, :data_directory)

  @moduledoc """
  Documentation for Lick.
  """

  @doc """
  Add one or more items to a list.

  ## Examples

      iex> Lick.add("colors", ["rose", "ochre"])
      :ok

  """
  def add(name, new_items) do
    updated_list = new_items ++ read(name)
    write(name, updated_list)
  end

  @doc """
  Read items from a list.
  """
  def read(name) do
    case File.read(path_to(name)) do
      {:ok, binary} -> String.split(binary, ",")
      {:error, :enoent} -> []
    end
  end

  @doc """
  Delete items from a list.
  """
  def delete(name, items) do
    updated_list = delete_items(name, items, read(name))
    write(name, updated_list)
  end

  defp delete_items(_, [], list), do: list
  defp delete_items(name, [item | rest], list) do
    delete_items(name, rest, List.delete(list, item))
  end

  defp path_to(name) do
    @data_directory
    |> Path.join("#{name}.lick")
    |> Path.expand()
  end

  defp write(name, items) do
    data = format_items(items)

    path_to(name)
    |> ensure_exists
    |> File.write(data)
  end

  defp format_items(items) do
    items
    |> Enum.uniq()
    |> Enum.join(",")
  end

  defp ensure_exists(path) do
    Path.dirname(path) |> File.mkdir_p()
    File.touch(path)
    path
  end
end
