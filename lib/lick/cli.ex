defmodule Lick.CLI do
  def main(argv) do
    argv
    |> parse_args
    |> run
  end

  def run(["r", name]), do: run(["read", name])

  def run(["read", name]) do
    Lick.read(name)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def run(["a" | args]), do: run(["add" | args])

  def run(["add", name | items]) do
    Lick.add(name, items)
  end

  def run(["d" | args]), do: run(["delete" | args])

  def run(["delete", name | items]) do
    Lick.delete(name, items)
  end

  defp parse_args(argv) do
    args =
      OptionParser.parse(
        argv,
        switches: [help: :boolean],
        alias: [h: :help]
      )

    case args do
      {[help: true], _, _} -> :help
      {_, [""], _} -> :help
      {_, args, _} -> args
    end
  end
end
