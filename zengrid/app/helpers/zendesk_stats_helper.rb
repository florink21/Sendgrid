module ZendeskStatsHelper
require "#{Rails.root}/lib/classes/zendesk"


def get_new_tickets
  returnHash = Hash.new
  begin
    newviews_response = Zendesk_api.get('https://sendgrid.zendesk.com/api/v2/views/24345347/count.json') # Get New Tickets count from ZenDesk API
    unless newviews_response["view_count"]["value"].nil? # Make sure we don't have a nil value from API call
      newtickets = newviews_response["view_count"]["value"]
      count = newtickets
    else
      count =  -1
    end
  rescue
    count = -99
  end

  begin
    newurgent_response = Zendesk_api.get('https://sendgrid.zendesk.com/api/v2/views/24345347/tickets.json') # Get Ticket Details for the New Queue
    tags_new = newurgent_response["tickets"][0]["tags"]
    if tags_new.include?('high_volume')
       newurgent = 1
    else
       newurgent = 0
    end
  rescue
     newurgent = -1
  end  

  returnHash = {"count" => count, "newurgent" => newurgent}
  puts returnHash
  return returnHash
end  

def get_aging_tickets
  returnHash = Hash.new
  begin
    agingviews_response = Zendesk_api.get('https://sendgrid.zendesk.com/api/v2/views/29161181/count.json') # Get Aging Tickets count from ZenDesk API
    unless agingviews_response["view_count"]["value"].nil? # Make sure we don't have a nil value from the API call
      agingtickets = agingviews_response["view_count"]["value"]
      count = agingtickets
    else  
      count  = -1
    end
  rescue
    # Hackaround... When Aging tickets are empty, ZenDesk is throwing a 401 Not Authenticated error. Assume all errors are this error and force count to 0
    count = 0
  end
    
  begin
    agingurgent_response = Zendesk_api.get('https://sendgrid.zendesk.com/api/v2/views/29161181/tickets.json') # Get Ticket Details for the New Queue
    tags_aging  = agingurgent_response["tickets"][0]["tags"]
    if tags_aging.include?('high_volume')
       agingurgent = 1
    else
       agingurgent = 0
    end
  rescue
    agingurgent = -99
  end
  
  returnHash = {"count" => count, "agingurgent" => agingurgent}
  puts returnHash
  return returnHash
end

end


     
