defmodule Issues.CLI do
  import Issues.TableFormatter, only: [print_table_for_columns: 2]
  @default_count 4

  @moduledoc """
  Handle command-line parsing and the disatch to varous functions that
  generate a table of the last N issues in a github project
  """

  def main(argv), do: argv |> parse_args |> process

  def run(argv) do
    argv |> parse_args |> process
  end
  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name and optionally the
  number of entries to format.

  Return a tuple of `{user, project, count}`, or :help if help was
  given.
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parse do
      {[help: true], _, _ }         -> :help
      {_,[user, project, count], _} -> {user, project, String.to_integer(count)}
      {_,[user, project], _}        -> {user, project, @default_count}
      _                             -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ <count> | #{@default_count} ]
    """

    System.halt(0)
  end
  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> convert_to_hashdicts
    |> oldest_first
    |> Enum.take(count)
    |> print_table_for_columns(~w|number created_at title|)
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, error}) do
    {_, message} = Map.fetch(error, "message")
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def convert_to_hashdicts(issues) do
    issues |> Enum.map(&Enum.into(&1, Map.new))
  end

  def oldest_first(issues) do
    Enum.sort issues, &(&1["created_at"] <= &2["created_at"])
  end
end
