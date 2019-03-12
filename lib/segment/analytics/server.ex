defmodule Segment.Analytics.Server do
  use GenServer

  require Logger

  alias Segment.Analytics.Http

  def init(_) do
    {:ok, %{}}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  # Client API

  def post(api) do
    GenServer.cast(__MODULE__, api)
  end

  # Server API

  def handle_cast(api, state) do
    function = api.method
    body = Poison.encode!(api)

    Http.post(function, body)
    |> log_result(function, body)

    {:noreply, state}
  end

  defp log_result({_, %{status_code: code}}, function, body) when code in 200..299 do
    # success
    Logger.debug("Segment #{function} call success: #{code} with body: #{body}")
  end

  defp log_result({_, %{status_code: code}}, function, body) do
    # HTTP failure
    Logger.debug("Segment #{function} call failed: #{code} with body: #{body}")
  end

  defp log_result(error, function, body) do
    # every other failure
    Logger.debug("Segment #{function} call failed: #{inspect(error)} with body: #{body}")
  end
end
