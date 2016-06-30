# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

CREDENTIALS = HashWithIndifferentAccess.new(YAML.load(File.read(File.expand_path('../config/credentials.yml', __FILE__))))
Slack.configure do |config|
  config.token = CREDENTIALS['SLACK_API_TOKEN']
end
