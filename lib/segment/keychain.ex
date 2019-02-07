defmodule Segment.Keychain do
  @type status :: :ok | :error

  @spec start_link(binary) :: {Segment.Keychain.status(), pid}
  def start_link(write_key) do
    Agent.start_link(fn -> write_key end, name: __MODULE__)
  end

  def write_key() do
    Agent.get(__MODULE__, fn state -> state end)
  end
end
