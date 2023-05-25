# LoggerLokiBackend

LoggerLokiBackend is an Elixir logger backend providing support for Logging directly to
[Grafana Loki](https://github.com/grafana/loki)

[![Hex.pm Version](http://img.shields.io/hexpm/v/logger_loki_backend.svg?style=flat)](https://hex.pm/packages/logger_loki_backend)

It is a fork of [LokiLogger](https://github.com/wardbekker/LokiLogger) that was updated to use
[Loki's new push API](https://grafana.com/docs/loki/latest/api/#push-log-entries-to-loki).

Also, the main intended usage of this is for development environment, where I normally run Loki
inside a docker container but my application runs on my machine, which make hard to implement a
solution to get the logs from my application into Loki, hence I won't be focusing right now on
production-grade performance.

## Known issues

* "works-on-my-machine" level of quality. Love to get your feedback in the repo's Github issues

## Features (and TODO)

* [x] Elixir Logger formatting
* [x] Elixir Logger metadata
    * [x] Loki Scope-Org-Id header for multi-tenancy
* [x] Timezone aware
* [X] Snappy compressed proto format in the HTTP Body  
* [X] Use [Loki's new push API](https://grafana.com/docs/loki/latest/api/#push-log-entries-to-loki)
* [ ] Proper tests.

## Installation

The package can be installed by adding `logger_loki_backend` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:logger_loki_backend, "~> 0.0.1"}
  ]
end
```

## Configuration

### Elixir Project

Loki Logger's behavior is controlled using the application configuration environment:

* __loki_host__ : the hostname of the syslog server e.g. http://localhost:3100
* __loki_labels__ : the Loki log labels used to select the log stream in e.g. Grafana 
* __loki_scope_org_id__: optional tenant ID for multitenancy. Currently not (yet?) supported in Grafana when enforced with `auth_enabled: true` in Loki config 
* __level__: logging threshold. Messages "above" this threshold will be discarded. The supported levels, ordered by precedence are :debug, :info, :warn, :error.
* __format__: the format message used to print logs. Defaults to: "$metadata level=$level $message". It may also be a {module, function} tuple that is invoked with the log level, the message, the current timestamp and the metadata.
* __metadata__: the metadata to be printed by $metadata. Defaults to to :all, which prints all metadata.
* __max_buffer__: the amount of entries to buffer before posting to the Loki REST api. Defaults to 32.  

For example, the following `config/config.exs` file sets up Loki Logger using
level debug, with `application` label `logger_loki_backend_library`. 

```elixir
use Mix.Config

config :logger,
       backends: [LoggerLokiBackend]

config :logger, :logger_loki_backend,
       level: :debug,
       format: "$metadata level=$level $message",
       metadata: :all,
       max_buffer: 300,
       loki_labels: %{application: "logger_loki_backend_library", elixir_node: node()},
       loki_host: "http://localhost:3100"
```

# Protobuff lib regeneration

only needed for development 

```shell script
protoc --proto_path=./lib/proto --elixir_out=./lib/proto lib/proto/push.proto
```

## License

LoggerLokiBackend is a fork of [LokiLogger](https://github.com/wardbekker/LokiLogger), which was
licensed under Apache v2.0 License and copyrighted to Ward Bekker.

Existing unmodified code still retains the same license, but new code is copyright of Bernardo
Amorim, also released under Apache v2.0 License.

Check [LICENSE](LICENSE) for more information.

