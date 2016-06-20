require 'net/https'
require 'uri'
require 'json'

class PivotalTrackerClient

BASE_URL = 'https://www.pivotaltracker.com/services/v5/projects/'

def create_story(token, title, project_id)
	puts token
	puts title
	puts project_id
	uri = URI.parse("#{BASE_URL}/#{project_id}/stories")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
	request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' =>'application/json'})
	request.body = { "current_state" => "started","name" => title}.to_json
	response = http.request(request)
	puts '!' * 100
	puts response.code
	puts response.body
    puts '!' * 100
    response
	end
end

