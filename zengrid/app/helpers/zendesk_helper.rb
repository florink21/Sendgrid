module ZendeskHelper

  def hi(tickets_to_update)
    tickets_to_update.each do |ticket_number|
    	puts ticket_number
    end
  end

  def update_events(tickets_to_update)
  	groups = {}
	group_response = Zendesk_api.get('https://sendgrid.zendesk.com/api/v2/groups.json')
	group_response["groups"].each do |group|  # create hash of group_id => group_name
		id = group["id"]
		name = group["name"]
		groups[id] = name
	end

	agents = {}
	agent_response = Zendesk_api.get('https://sendgrid.zendesk.com/api/v2/groups/57659/users.json') # grab list of users for Support Group - id 57659
	agent_response["users"].each do |user|  # create hash of agent_id => agent_name
		id = user["id"]
		name = user["name"]
		agents[id] = name
	end
		
	tickets_to_update.each do |ticket_number|

		puts ticket_number

		AuditEvent.where(:ticket_id => ticket_number).delete_all   # delete all audit events for this ticket so we won't get dupes

		ticket = "https://sendgrid.zendesk.com/api/v2/tickets/" + ticket_number.to_s + "/audits.json"
		audit_response = Zendesk_api.get(ticket)

		previous_status = ""
		previous_audit_time = Time.now	#just to set to a time event - Time.now not actually used

		time_since_requester_update = 0  #new
		time_since_agent_update = 0      #new

		if audit_response["audits"]  # ignore deleted tickets, otherwise will end loop with error

			audit_size = audit_response["audits"].size # used to set ae.last = true for last audit event

			channel = audit_response["audits"][0]["via"]["channel"]	
			group_id = ""
			assignee_id = ""
			status = ""
			sla_due = ""
			subject = ""
			username = ""
			package = ""
			category = ""
			tags = ""

			

			audit_response["audits"].each_with_index do |audit, index|
				
				ae = AuditEvent.new
				ae.ticket_id = ticket_number
				previous_audit_time = Time.parse(audit["created_at"]).localtime if index == 0
				audit_time = Time.parse(audit["created_at"]).localtime
				ae.created_at = audit_time
			
			
				audit["events"].each do |event|
					group_id = event["value"] if event["field_name"] == "group_id"
					assignee_id = event["value"] if event["field_name"] == "assignee_id"
					status = event["value"] if event["field_name"] == "status"
					subject = event["value"] if event["field_name"] == "subject"
					username = event["value"] if event["field_name"] == "182791" 
					package = event["value"] if event["field_name"] == "20285362" 
					category = event["value"] if event["field_name"] == "20032468"
					if event["field_name"] == "tags" then 
						event["value"].each do |value|
							tags << value 
							tags << " " 
						end
					end
				end

				group_name = groups[group_id.to_i]
				agent_name = agents[assignee_id.to_i]

				ae.channel = channel
				ae.group_name = group_name
				ae.agent = agent_name
				ae.username = username
				ae.package = package
				ae.category = category
				ae.previous_status = previous_status
				ae.current_status = status

				case
				when status == ""        && previous_status == ""
					time_since_requester_update = 0
					case_code = 1
				when status == "new"     && previous_status == ""
					time_since_requester_update = 0
					case_code = 2
				when status == "new"     && previous_status == "new"
					time_since_requester_update = time_since_requester_update + ((audit_time - previous_audit_time)/60).to_i
					case_code = 3
				when status == "new"     && previous_status == "solved"
					time_since_requester_update = 0
					case_code = 3.5		
				when status == "open"    && previous_status == ""
					time_since_requester_update = 0
 					case_code = 4
 				when status == "open"    && previous_status == "new"
 					time_since_requester_update = time_since_requester_update + ((audit_time - previous_audit_time)/60).to_i
 					case_code = 5
 				when status == "open"    && previous_status == "open"
 					time_since_requester_update = time_since_requester_update + ((audit_time - previous_audit_time)/60).to_i
 					case_code = 6
 				when status == "open"    && previous_status == "pending"
 					time_since_requester_update = 0
 					case_code = 7
 				when status == "open"    && previous_status == "solved"
 					time_since_requester_update = 0
					case_code = 8
				when status == "pending" && previous_status == ""
					time_since_requester_update = 0
					case_code = 9
				when status == "pending" && previous_status == "new"
					time_since_requester_update = time_since_requester_update + ((audit_time - previous_audit_time)/60).to_i
 					case_code = 10
 				when status == "pending" && previous_status == "open"
 					time_since_requester_update = time_since_requester_update + ((audit_time - previous_audit_time)/60).to_i
 					case_code = 11
 				when status == "pending" && previous_status == "pending"
 					time_since_requester_update = 0
					case_code = 12
				when status == "pending" && previous_status == "solved"
					time_since_requester_update = 0
 					case_code = 13
 				when status == "solved" && previous_status == ""
					time_since_requester_update = time_since_requester_update + ((audit_time - previous_audit_time)/60).to_i
 					case_code = 131
 				when status == "solved"  && previous_status == "new"
 					time_since_requester_update = time_since_requester_update + ((audit_time - previous_audit_time)/60).to_i
 					case_code = 14
 				when status == "solved"  && previous_status == "open"
 					time_since_requester_update = time_since_requester_update + ((audit_time - previous_audit_time)/60).to_i
 					case_code = 15
 				when status == "solved"  && previous_status == "pending"
 					time_since_requester_update = 0
 					case_code = 16
 				when status == "solved"  && previous_status == "solved"
 					time_since_requester_update = 0
 					case_code = 17
 				when status == "closed"  && previous_status == "new"
 					time_since_requester_update = time_since_requester_update + ((audit_time - previous_audit_time)/60).to_i
 					case_code = 18
 				when status == "closed"  && previous_status == "open"
 					time_since_requester_update = time_since_requester_update + ((audit_time - previous_audit_time)/60).to_i
 					case_code = 19
 				when status == "closed"  && previous_status == "pending"
 					time_since_requester_update = 0	
 					case_code = 20
 				when status == "closed"  && previous_status == "solved"
 					time_since_requester_update = 0
					case_code = 21
				when status == "closed"  && previous_status == "closed"
 					time_since_requester_update = 0
					case_code = 22
				else
					puts 'Error with time_since_requester_update'
					case_code =  23
				end


				ae.time_since_requester_update = time_since_requester_update
				

				ae.subject = subject
				ae.tags = tags.chop #get rid of final sapce in tags field	
				
				# previous_audit_time = audit_time if previous_status != status # only update previous time if there's been a change in status
				previous_audit_time = audit_time
				previous_status = status #now safe to update previous_status

			
				if ae.last then puts "ae.last.before " + ae.last end

				if index == (audit_size-1)
					then ae.last = true
				end 

				ae.save
			end
		end
	end
  end

end