require 'net/https'
require 'uri'
require 'json'

class PivotalTrackerClient

BASE_URL = 'https://www.pivotaltracker.com/services/v5/projects/'

def create_story(token, project_id, title)
	uri = URI.parse("#{BASE_URL}/#{project_id}/stories")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' =>'application/json', "X-TrackerToken" => token})
	request.body = { 
		"current_state" => "unstarted",
		"name" => title, 
		"estimate":5,
		"story_type": "bug"
		}.to_json
	response = http.request(request)
    response
	end

def can_make_story?(token, project_id, email_from_slack)
	uri = URI.parse("#{BASE_URL}/#{project_id}/memberships")
	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.request_uri, {'Content-Type' =>'application/json', "X-TrackerToken" => token})
	response = http.request(request)
	response.each do |member|
		email_from_tracker = member['person']['email']
		role = member['role'] #owner
		if email_from_tracker == email_from_slack && role == 'owner' || role == 'member'
			return true
	end
	return false
end

end

