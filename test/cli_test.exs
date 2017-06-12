defmodule OptionParserExploratoryTests do
  use ExUnit.Case

  def parse(list), do: OptionParser.parse(list, switches: [help: :boolean], aliases: [h: :help])

  test 'parsing' do
    assert {[help: true], _, _} = parse(["--help"])
  end

  test 'flag' do
    assert {[help: true], ["please"], _} = parse(["--help", "please"])
  end

  test 'OptionParser doesn\'t grok non-bitstrings' do
    assert {[], ['--help'], _} = parse(['--help'])
  end 
end

defmodule CLITest do
  use ExUnit.Case
  import Issues.CLI, only: [parse_args: 1, oldest_first: 1, convert_to_hashdicts: 1]

  test 'parsing --help yields :help' do
    assert :help == parse_args(["--help"])
  end

  test '-h gives :help' do
    assert :help == parse_args(["-h"])
  end

  test 'help overrides other arguments' do
    assert :help == parse_args(["--help", "please"])
    assert :help == parse_args(["-h", "please"])
  end

  test 'passing uname/repo/count returns a tuple' do
    assert {"user", "project", 1} == parse_args(["user", "project", "1"])
  end

  test 'count is defaulted if omitted' do
    assert {"user", "project", 4} == parse_args(["user", "project"])
  end

  test 'sorts issues in the right way' do
    result = oldest_first(fake_created_at_list(["a", "b", "c"]))
    issues = for issue <- result, do: issue["created_at"]
    assert issues == ~w{a b c}
  end

  defp fake_created_at_list(values) do
    data = for value <- values, do: [{"created_at", value}, {"other_data", "xxx"}]
    convert_to_hashdicts data
  end
end
