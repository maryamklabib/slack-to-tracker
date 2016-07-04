require ::File.expand_path("./../../models/PivotalTrackerClient.rb", __FILE__)

class StoriesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  CREDENTIALS = HashWithIndifferentAccess.new(YAML.load(File.read(File.expand_path('../../../config/credentials.yml', __FILE__))))
  PROJECT_ID = CREDENTIALS['project_id']
  TRACKER_TOKEN = CREDENTIALS['tracker_token']

  def index
  end

  def create
    title = params[:text]
    slack_user_id = params[:user_id]

    slack_client = Slack::Web::Client.new
    response = slack_client.users_info(user: slack_user_id)
    email = response['user']['profile']['email']
    slack_username = response['user']['name']

    tracker_client = PivotalTrackerClient.new(TRACKER_TOKEN, PROJECT_ID)
    if tracker_client.can_make_story?(email)
    	url = tracker_client.create_story(title)
      render json: {
                  "parse": "full",
                  "link_names": 1,
                  "response_type": "in_channel",
                  "text": "@#{slack_username} created a :tracker_bug: in the Ops Manager backlog titled:\n*#{title}*\n#{url}"
                  }
    else
      render 500
    end
  end
end
