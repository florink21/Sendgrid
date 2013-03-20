# Need to run local zendesk rake tasks with "foreman run rake..." to load the environment variables in the .env file


require 'rubygems'
require 'httparty'
# require 'Pry'
require "#{Rails.root}/app/helpers/zendesk_helper"
require "#{Rails.root}/lib/classes/zendesk"
include ZendeskHelper


	  	task :hi, [:first_ticket, :last_ticket] => :environment do |t,args|
	  		user = User.first
	  		puts user.email

	  		ticket_number = args.first_ticket.to_i
	  		tickets_to_update = []
	  		until ticket_number > args.last_ticket.to_i do
	  			tickets_to_update << ticket_number
	  			ticket_number += 1
	  		end


	    	hi(tickets_to_update)
	  	end

	  	task :zen_seeding, [:first_ticket, :last_ticket] => :environment do |t, args|
	  		puts "Seeding from #{args.first_ticket} to #{args.last_ticket}"

	  		ticket_number = args.first_ticket.to_i
	  		tickets_to_update = []

	  		until ticket_number > args.last_ticket.to_i do
	  			tickets_to_update << ticket_number
	  			ticket_number += 1
	  		end

			update_events(tickets_to_update)
			puts "Done!"
		end

		task :zen_update, [:first_ticket, :last_ticket] => :environment do |t, args|
			puts "Updating all tickets from #{args.first_ticket} to #{args.last_ticket} which are not closed"

			ticket_number = args.first_ticket.to_i
	  		tickets_to_update = []

	  		until ticket_number > args.last_ticket.to_i do
	  			if AuditEvent.where(:ticket_id => ticket_number) == []
	  				tickets_to_update << ticket_number
	  			elsif AuditEvent.where(:ticket_id => ticket_number).last.current_status != "closed"
	  				tickets_to_update << ticket_number
	  			end
	  	
	  			ticket_number += 1
	  		end

			update_events(tickets_to_update)
			puts "Done!"
		end

		task :zen_incremental => :environment do
			# put setting in database to hold start time for incremental update_events - one time initialization

			# call every 10 minutes on heroku
			puts "Time is " + Time.now.to_s
			number_of_tickets_updated = 0
			tickets_to_update = []

			incremental_request = "https://sendgrid.zendesk.com/api/v2/exports/tickets.json?start_time=" + Setting.zen_incremental_time.to_s
			incremental_response = Zendesk_api.get(incremental_request)

			incremental_response["results"].each do |result|
				tickets_to_update << result["id"]
				number_of_tickets_updated += 1
			end

			Setting.zen_incremental_time = incremental_response["end_time"]

			update_events(tickets_to_update)
			puts "Updated " + number_of_tickets_updated.to_s + " tickets."	
			puts "Done!"



		end
	

