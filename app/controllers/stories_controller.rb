require '~/code/slack-to-tracker/app/models/PivotalTrackerClient.rb'

class StoriesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  TRACKER_TOKEN = HashWithIndifferentAccess.new(YAML.load(File.read(File.expand_path('../../../config/credentials.yml', __FILE__))))

  def index
  end

  def create
  	token = params[:token]
  	title = params[:title]
  	project_id = params[:project_id]
  	client = PivotalTrackerClient.new
  	response = client.create_story(token, title, project_id)
  	render json: response 
  end
end