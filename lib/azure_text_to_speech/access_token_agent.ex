defmodule AzureTextToSpeech.AccessTokenAgent do
  use Agent

  def start_link(_initial_value) do
    Agent.start_link(fn -> %{token: nil, time: DateTime.from_unix!(0)} end, name: __MODULE__)
  end

  def get, do: Agent.get(__MODULE__, & &1)

  def update(token) do
    Agent.update(__MODULE__, fn _ ->
      %{token: token, time: DateTime.now!("Etc/UTC")}
    end)
  end
end
