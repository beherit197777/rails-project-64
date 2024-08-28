Sentry.init do |config|
  config.dsn = "https://examplePublicKey@o0.ingest.sentry.io/0"
  # enable performance monitoring
  config.enable_tracing = true
  # get breadcrumbs from logs
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]
end
