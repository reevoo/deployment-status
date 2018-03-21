#!/usr/bin/env puma # rubocop:disable Lint/ScriptPermission

port ENV.fetch("PORT", 9292)
workers Integer(ENV.fetch("WEB_CONCURRENCY", 1))

threads(
  Integer(ENV.fetch("WEB_MIN_THREADS", 1)),
  Integer(ENV.fetch("WEB_MAX_THREADS", 5)),
)

lowlevel_error_handler do |error|
  headers = { "Content-Type" => "text/plain" }

  case error
  when ::Rack::Utils::InvalidParameterError
    [400, headers, ["400 Bad Request: The query parameters are invalid."]]
  else
    [500, headers, ["500 Server Error: Unhandled low-level error: we've been notified."]]
  end
end

preload_app!
