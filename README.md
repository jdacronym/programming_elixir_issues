# Issues

The GitHub Issues project from Programming Elixir, with additions/enhancements
where I got out ahead of Dave Thomas or had an Opinion to share.

## Synopsis

The following should give you a short table of issue numbers, dates and titles
for github issues on the elixir language project.

 mix run -e 'Issues.GithubIssues.fetch(["elixir-lang", "elixir", 4])'
 
or `iex -S mix` in the project and run the above directly from IEx. Finally,
you can compile the escript version with `mix escript` build and run it from
your terminal emulator of choice:

```
$ ./issues elixir-lang elixir
```

## Installation

The package can be installed by adding `issues` to your list of dependencies in
`mix.exs` thusly:

```elixir
def deps do
  [{:issues, github: "jdacronym/issues"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/issues](https://hexdocs.pm/issues).
