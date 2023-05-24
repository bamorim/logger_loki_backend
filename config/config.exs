import Config

config :logger,
  backends: [LoggerLokiBackend]

config :logger, :logger_loki_backend,
  level: :debug,
  format: "$metadata level=$level $message",
  metadata: :all,
  max_buffer: 300,
  loki_labels: %{application: "logger_loki_backend_library", elixir_node: node()},
  loki_host: "http://localhost:3100",
  loki_scope_org_id: "acme_inc"
