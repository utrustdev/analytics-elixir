defmodule Segment do
  use Supervisor

  def start_link(write_key) do
    Supervisor.start_link(__MODULE__, write_key, name: __MODULE__)
  end

  def init(write_key) do
    children = [
      worker(Segment.Keychain, [write_key]),
      Segment.Analytics.Server
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
