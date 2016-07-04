require 'net/https'
require 'uri'
require 'json'

class PivotalTrackerClient

	def initialize(token, project_id)
		@token = token
		@project_id = project_id
	end


BASE_URL = 'https://www.pivotaltracker.com/services/v5/projects/'

def create_story(title)
	uri = URI.parse("#{BASE_URL}#{@project_id}/stories")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' =>'application/json', "X-TrackerToken" => @token})
	request.body = {
		"current_state" => "unstarted",
		"name" => title,
		"story_type": "bug"
		}.to_json
	response = http.request(request)
	code = response.code
	response = JSON.parse(response.body)
	return response['url']
	end

def can_make_story?(email_from_slack)
	uri = URI.parse("#{BASE_URL}#{@project_id}/memberships")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	request = Net::HTTP::Get.new(uri.request_uri, {'Content-Type' =>'application/json', "X-TrackerToken" => @token})
	response = http.request(request)
	response = JSON.parse(response.body)
	response.each do |member|
		email_from_tracker = member['person']['email']
		role = member['role']
		if email_from_tracker == email_from_slack
			if role == 'owner' || role == 'member'
				return true
			end
		end
	end
	false
end

end
