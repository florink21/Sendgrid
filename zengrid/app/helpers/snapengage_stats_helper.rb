module SnapengageStatsHelper

  def get_active_agents
    return self.get_snapengage_stats[:agents_on_chats]
  end

  def get_active_chats
    return self.get_snapengage_stats[:total_chats]
  end

  def get_snapengage_stats
  	returnHash = Hash.new

	# SnapEngage Regular URL - used to display all Basic URL information, team status, and chat count and visitor wait time graphs 
	url = "https://www.snapengage.com/snapabug/teamdashboardaction?k=OxaoPlYMeFY%3D&detail=true"

	# Create a RestClient instance of the url variable
	resource = RestClient::Resource.new url
	# Do an HTTP POST to the url to receive the data
	resp = resource.post '/data'

	# LIST - all of the images used for agent statuses
	chat_avail = "/img/chat/chat_available.png"
	chat_paused_avail = "/img/chat/chat_paused_online.png"
	chat_offline = "/img/chat/chat_offline.png"
	chat_paused_offline = "/img/chat/chat_paused_offline.png"

	# create a Nokogiri HTML instance of the HTTP POST response; used for parsing the POST's data
	doc = Nokogiri::HTML(resp)

	# clear the total_chats variable; used to count the total number of chats
	total_chats = 0
	# clear the agent_on_chats variable; used to count the total number of agents on chats
	agents_on_chats = 0

	agent_info_str = ""

	# Search for every instance of <div class="agent-panel">; 
	# Each agent has one of these divs
	doc.css('div.agent-panel').each do |agent_panel| 
	  # Search for every instance of:
	  # <div class="agent-alias">
	  #   <span class="chatagenttext">
	  # This contains the agent's name
	  agent = agent_panel.at_css('div.agent-alias span.chatagenttext').text
	  
	  # Search for every instance of:
	  # <div class="agent-panel-top">
	  #   <span class="chatagenttext">
	  # This indicates the number of active chats
	  # Caveat: I only check the first index [0] for this number;
	  #         if a user has 10 or more chats, this won't be accurate.
	  chats = agent_panel.at_css('div.agent-panel-top span.chatagenttext').text[0]
	  total_chats += chats.to_i

	  # Search for every instance of <img class="status-img">;
	  # This image indicates the agent's status
	  image = agent_panel.at_css('img.status-img')['src'].to_s
	  case image
	  when chat_avail # Online, available agent
	    agents_on_chats += 1
	    agent_info_str += agent + ", " + chats + ", " + image + "; "
	  # when chat_paused_avail # Online, not available agent
	  #   agents_on_chats += 1
	  #   agent_info_str += agent + ", " + chats + ", " + image + "; "
	  end
	end
	returnHash = {total_chats: total_chats, agents_on_chats: agents_on_chats, agent_info: agent_info_str}
	return returnHash
  end

end
