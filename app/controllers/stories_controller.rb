#require '~/code/slack-to-tracker/app/models/PivotalTrackerClient.rb'

class StoriesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  FILE = HashWithIndifferentAccess.new(YAML.load(File.read(File.expand_path('../../../config/credentials.yml', __FILE__))))
  PROJECT_ID = FILE['project_id']
  TRACKER_TOKEN = FILE['tracker_token']
  def index
  end

  def create
  	token = TRACKER_TOKEN
  	project_id = PROJECT_ID
    title = params[:text]
  	client = PivotalTrackerClient.new
  	response = client.create_story(token, title, project_id)
  	render json: response 
  end
end