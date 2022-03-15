defmodule AzureTextToSpeech.AccessTokenAgent do
  @moduledoc false
  use Agent

  @spec start_link(any) :: Agent.on_start()
  def start_link(_initial_value) do
    Agent.start_link(fn -> %{token: nil, time: DateTime.from_unix!(0)} end, name: __MODULE__)
  end

  @spec get :: map()
  def get, do: Agent.get(__MODULE__, & &1)

  @spec update(binary()) :: :ok
  def update(token) when is_binary(token) do
    Agent.update(__MODULE__, fn _ ->
      %{token: token, time: DateTime.now!("Etc/UTC")}
    end)
  end
end
