defmodule Issues.GitHubIssues do
  require Logger
  @user_agent [ {"User-agent", "Elixir by @picandocodigo"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    Logger.info("Fetching @#{user}'s project #{project}")
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info("Success")
    Logger.debug fn -> inspect(body) end
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.error "Error #{status_code} returned"
    {:error, Poison.Parser.parse!(body)}
  end
end
