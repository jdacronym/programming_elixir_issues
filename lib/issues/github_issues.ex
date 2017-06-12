defmodule Issues.GithubIssues do
  require Logger

  @user_agent [ { "User-agent", "Elixir dave@pragprog.com"} ]

  def fetch(user, project) do
    Logger.info "Fetching user #{user}'s project #{project}"
    issues_url(user, project) |> get(@user_agent) |> handle_response
  end

  @repos_path Application.get_env(:issues, :github_url)
  def issues_url(user, project), do: "#{@repos_path}/#{user}/#{project}/issues"

  def get(path, headers), do: HTTPoison.get(path, headers) |> unwrap

  def handle_response(%{status_code: 200, body: body}), do: {:ok, decode(body)}
  def handle_response(%{status_code: status, body: body}) do
    Logger.error("Error status #{status} returned")
    {:error, decode(body)}
  end

  # destructure {:ok, stuff_you_actually_want} tuples without skipping matching
  def unwrap({:ok, body}), do: body

  # use Poison (instead of the :jsx) and destructure the tuple that comes out
  def decode(resp), do: Poison.decode(resp) |> unwrap
end
