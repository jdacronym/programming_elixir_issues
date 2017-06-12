defmodule Issues.TableFormatter do
  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  @doc """
  Takes a list of row data (each row a Map), and a list of headers. Prints a
  table to STDOUT with a column of data under each header. Columns expand to
  the width of their largest element. 
  """

  def print_table_for_columns(rows, headers) do
    data_by_column = split_into_columns(rows, headers)
    column_widths = widths_of(data_by_column)
    format = format_for(column_widths)

    puts_one_line_in_columns headers, format
    IO.puts separator(column_widths)
    puts_in_columns data_by_column, format
  end

  @doc """
  Given a list of rows, each row a keyed list of columns, return a list
  containing list of the data split into columns. 'headers' contains the list
  of columns to extract.

  ## Ex:
    iex> list = [Enum.into([{"a", "1"}, {"b", "2"}, {"c", "3"}], Map.new),
    ...>   Enum.into([{"a", "4"}, {"b", "5"}, {"c", "6"}], Map.new)]
    iex> Issues.TableFormatter.split_into_columns(list, ~w|a b c|)
    [ ["1", "4"], ["2", "5"], ["3", "6"] ]
  """
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  @doc """
  Return a bitstring version of the parameter.

  # Ex:
    iex> Issues.TableFormatter.printable("a")
    "a"
    iex> Issues.TableFormatter.printable(99)
    "99"
  """
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end

  @doc """
  Given column widths from the above function widths_of/1, returns a template
  string for each row of the table. Each field is a right-justified string and
  the string is terminated with a newline. Used with the sprintf-like
  :io.format/2 

  # Ex:
    iex> Issues.TableFormatter.format_for([5,6,9])
    "~-5s | ~-6s | ~-9s~n"
  """
  def format_for(column_widths) do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end
