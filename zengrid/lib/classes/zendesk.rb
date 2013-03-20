class Zendesk_api
# binding.pry
	include HTTParty
	format :json
	basic_auth ENV['ZD_USERNAME'], ENV['ZD_PASSWORD']
end

