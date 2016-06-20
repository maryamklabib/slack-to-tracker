require 'net/https'
require 'uri'
require 'json'

class PivotalTrackerClient

BASE_URL = 'https://www.pivotaltracker.com/services/v5/projects/'

def create_story(token, title, project_id)
	uri = URI.parse("#{BASE_URL}/#{project_id}/stories")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' =>'application/json', "X-TrackerToken" => token})
	request.body = { "current_state" => "started","name" => title, "estimate":5}.to_json
	response = http.request(request)
    response
	end
end

