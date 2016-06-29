require 'net/https'
require 'uri'
require 'json'

class SlackClient

BASE_URL = 'https://slack.com/api/users.info'

def id_to_email(token, user_id)
	uri = URI.parse("#{BASE_URL}")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	request = Net::HTTP::Get.new(uri.request_uri, {'Content-Type' =>'application/json'})
	request.body = {
		"token" => token,
		"user" => user_id,
		}.to_json
	response = http.request(request)
  email = response['user']['profile']['email']
	email
end

def can_make_story(project_id, email)
	return true
end

end
