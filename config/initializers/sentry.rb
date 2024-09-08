# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://6b3f5382b6c85662cc6a090e74019c44@o4506423961452544.ingest.sentry.io/4506423971479552'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
end
