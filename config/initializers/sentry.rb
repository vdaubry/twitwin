require 'raven'

Raven.configure do |config|
  config.dsn = 'https://565294d68b5b4027ab3a2d61a1f8e2cb:d234a338fc8f4b758e97be28417b425e@app.getsentry.com/51329'
  config.environments = %w[ production ]
end