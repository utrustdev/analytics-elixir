defmodule Segment do
  use Supervisor

  def start_link(write_key) do
    children = [
      worker(Segment.Keychain, [write_key]),
      Segment.Analytics.Server
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
