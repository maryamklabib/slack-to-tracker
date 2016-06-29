# require '~/code/slack-to-tracker/app/models/PivotalTrackerClient.rb'

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

    slack_client = SlackClient.new
    email = slack_client.id_to_email(slack_user_id)

    client = PivotalTrackerClient.new
    if client.can_make_story?(email, PROJECT_ID)
    	client.create_story(TRACKER_TOKEN, title, PROJECT_ID)
    end
  end
end
