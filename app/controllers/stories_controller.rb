require '~/code/slack-to-tracker/app/models/PivotalTrackerClient.rb'

class StoriesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  FILE = HashWithIndifferentAccess.new(YAML.load(File.read(File.expand_path('../../../config/credentials.yml', __FILE__))))
  PROJECT_ID = FILE['project_id']
  TRACKER_TOKEN = FILE['tracker_token']

  def index
  end

  def create
    title = params[:text]
    slack_user_id = params[:user_id]

    slack_client = Slack::Web::Client.new
    response = slack_client.users_info(user: slack_user_id)
    email = response['user']['profile']['email']

    tracker_client = PivotalTrackerClient.new(TRACKER_TOKEN, PROJECT_ID)
    if tracker_client.can_make_story?(email)
    	tracker_client.create_story(title)
    end
  end
end
