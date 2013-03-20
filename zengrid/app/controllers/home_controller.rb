class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index

	waiting_tickets_last_events = []
	display = []

	current_profile = Profile.where(user_id: current_user.id).first_or_create

	groups = []
	if current_profile.group_backend then groups << "Backend" end
	if current_profile.group_billing then groups << "Billing" end
	if current_profile.group_compliance then groups << "Compliance" end
	if current_profile.group_desktop_support then groups << "Desktop Support" end
	if current_profile.group_dev_relations then groups << "Dev Relations" end
	if current_profile.group_escalation then groups << "Escalation" end
	if current_profile.group_frontend then groups << "Frontend" end
	if current_profile.group_hp then groups << "HP" end
	if current_profile.group_marketing then groups << "Marketing" end
	if current_profile.group_qa_admins then groups << "QA Admins" end
	if current_profile.group_sales then groups << "Sales" end
	if current_profile.group_support then groups << "Support" end


	tag_ids = []
	if !current_profile.tag_live_chat then tag_ids << "%live_chat%" end
	if !current_profile.tag_email then tag_ids << "%email%" end
	if !current_profile.tag_claimed then tag_ids << "%claimed%" end
	if !current_profile.tag_keep_open then tag_ids << "%keep_open%" end
	if !current_profile.tag_billing then tag_ids << "%billing%" end
	if !current_profile.tag_quiet then tag_ids << "%quiet%" end	

	ticket_status = []
	if current_profile.status_new then ticket_status << "New" end
	if current_profile.status_open then ticket_status << "Open" end
	if current_profile.status_pending then ticket_status << "Pending" end
	if current_profile.status_solved then ticket_status << "Solved" end
	if current_profile.status_closed then ticket_status << "Closed" end


	if tag_ids == [] then
		waiting_tickets_last_events = AuditEvent.include_groups(groups).where{ current_status.like_any ticket_status }.last_event
	else
		waiting_tickets_last_events = AuditEvent.include_groups(groups).where{ tags.not_like_all tag_ids}.where{ current_status.like_any ticket_status }.last_event
	end

	waiting_tickets_last_events_aging = []
	waiting_tickets_last_events.each do |waiting_ticket|
		if (((waiting_ticket.current_status == 'new') || (waiting_ticket.current_status == 'open')) && ((waiting_ticket.time_since_requester_update + (Time.now.utc - waiting_ticket.created_at)/60) > 60))
			waiting_ticket.time_since_requester_update  += (Time.now.utc - waiting_ticket.created_at)/60 
			waiting_tickets_last_events_aging << waiting_ticket
		end
	end


=begin

	start_time_euro = Time.new(Time.now.year,Time.now.month,Time.now.day, 22,0,0, "-07:00").yesterday
	end_time_euro = Time.new(Time.now.year,Time.now.month,Time.now.day, 8,0,0, "-07:00")

	start_time_usa = Time.new(Time.now.year,Time.now.month,Time.now.day, 8,0,0, "-07:00")
	end_time_usa = Time.new(Time.now.year,Time.now.month,Time.now.day, 15,0,0, "-07:00")

        start_time_evening = Time.new(Time.now.year,Time.now.month,Time.now.day, 17,0,0, "-07:00")
        end_time_evening = Time.new(Time.now.year,Time.now.month,Time.now.day, 22,0,0, "-07:00")

	time=Time.new
=end

	now = Time.now
        day = now.wday
        hour = now.hour
	timezone = "-07:00"
	ago1 = 1.day.ago.localtime
	ago2 = 2.day.ago.localtime
	ago3 = 3.day.ago.localtime
	ago4 = 4.day.ago.localtime
	ago5 = 5.day.ago.localtime
	ago6 = 6.day.ago.localtime
	ago7 = 7.day.ago.localtime
	ago8 = 8.day.ago.localtime
	ago9 = 9.day.ago.localtime
	ahead1 = now.tomorrow
	ahead2 = now+2.day

        # if the day is Sunday (0)
        if (day == 0) then                
                # Sunday before 10pm - weekend: last is the previous weekend (9-7 days ago); current is the current weekend (2 day ago - today)
		# Sunday before 10pm - euro: last is Thursday-Friday; current is 0
                if (hour < 22) then
			# Sunday last weekend - Starts 9 days ago (Friday)  at 10pm (22); Ends 7 days ago (Sunday) at 10pm (22)
			start_time_weekend_last = Time.new(ago9.year, ago9.month, ago9.day, 22,0,0,timezone)
			end_time_weekend_last = Time.new(ago7.year, ago7.month, ago7.day, 22,0,0,timezone)
			# Sunday current weekend - Starts 2 days ago (Friday)  at 10pm (22); Ends today (Sunday) at 10pm (22)
			start_time_weekend_current = Time.new(ago2.year, ago2.month, ago2.day, 22,0,0,timezone)
			end_time_weekend_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)

			# Sunday last euro - Starts 3 days ago (Thursday) at 10pm (22); Ends 2 days ago (Friday) at 8am (9)
			start_time_euro_last = Time.new(ago3.year, ago3.month, ago3.day, 22,0,0,timezone)
			end_time_euro_last = Time.new(ago2.year, ago2.month, ago2.day, 8,0,0,timezone)
			# Sunday current euro - same start and end times since euro is not included in the weekend
			start_time_euro_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
			end_time_euro_current = start_time_euro_current

		# Sunday between 10-11:59pm - weekend: last is the previous weekend (2 days ago - today); current is 0
		# Sunday between 10-11:59pm - euro: last is Thursday-Friday; current is Sunday-Monday
		else
			# Sunday last weekend - Starts 2 days ago (Friday)  at 10pm (22); Ends today (Sunday) at 10pm (22)
			start_time_weekend_last = Time.new(ago2.year, ago2.month, ago2.day, 22,0,0,timezone)
			end_time_weekend_last = Time.new(now.year, now.month, now.day, 22,0,0,timezone)
			# Sunday current weekend - same start and end times since weekend is not included in the weekdays
			start_time_weekend_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
			end_time_weekend_current = start_time_weekend_current

			# Sunday last euro - Starts 3 days ago (Thursday) at 10pm (22); Ends 2 days ago (Friday) at 8am (9)
			start_time_euro_last = Time.new(ago3.year, ago3.month, ago3.day, 22,0,0,timezone)
			end_time_euro_last = Time.new(ago2.year, ago2.month, ago2.day, 8,0,0,timezone)
			# Sunday current euro - same start and end times since euro is not included in the weekend
			start_time_euro_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)
			end_time_euro_current = Time.new(ahead1.year, ahead1.month, ahead1.day, 8,0,0,timezone)
		end
				
		# Sunday last usa - Starts 2 days ago (Friday) at 8am (8); Ends 2 days ago (Friday) at 5pm (17)
		start_time_usa_last = Time.new(ago2.year, ago2.month, ago2.day, 8,0,0,timezone)
		end_time_usa_last = Time.new(ago2.year, ago2.month, ago2.day, 17,0,0,timezone)
		# Sunday current usa - same start and end times since usa is not included in the weekend
		start_time_usa_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
		end_time_usa_current = start_time_usa_current
				
                # Sunday last evening - Starts 2 days ago (Friday) at 5pm (17); Ends 2 days ago (Friday) at 10pm (22)
                start_time_evening_last = Time.new(ago2.year, ago2.month, ago2.day, 17,0,0,timezone)
                end_time_evening_last = Time.new(ago2.year, ago2.month, ago2.day, 22,0,0,timezone)
                # Sunday current usa - same start and end times since evening is not included in the weekend
                start_time_evening_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
                end_time_evening_current = start_time_evening_current

		
		# if the day is Monday (1)
        elsif (day == 1) then
                # Monday last weekend - Starts 3 days ago (Friday)  at 10pm (22); Ends 1 days ago (Sunday) at 10pm (22)
                start_time_weekend_last = Time.new(ago3.year, ago3.month, ago3.day, 22,0,0,timezone)
                end_time_weekend_last = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                # Monday current weekend - same start and end times since weekend is not included in the weekdays
                start_time_weekend_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
                end_time_weekend_current = start_time_weekend_current
                
                # Monday before 10pm - last day is Thursday-Friday; current day is Sunday-Monday
                if (hour < 22) then
                	# Monday last euro - Starts 4 days ago (Thursday) at 10pm (22); Ends 3 days ago (Friday) at 8am (8)
                	start_time_euro_last = Time.new(ago4.year, ago4.month, ago4.day, 22,0,0,timezone)
                	end_time_euro_last = Time.new(ago3.year, ago3.month, ago3.day, 8,0,0,timezone)
                	# Monday current euro - Starts 1 day ago (Sunday) at 10pm (22); Ends today (Monday) at 8am (8)
                	start_time_euro_current = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                	end_time_euro_current = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
			# Monday between 10-11:59pm - last is Sunday-Monday; current is Monday-Tuesday
		else
			# Monday last euro - Starts 1 day ago (Sunday) at 10pm (22); Ends today (Monday) at 8am (8)
                	start_time_euro_last = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                	end_time_euro_last = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
                	# Monday current euro - Starts today (Monday) at 10pm (22); Ends tomorrow (Tuesdayday) at 8am (8)
                	start_time_euro_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)
                	end_time_euro_current = Time.new(ahead1.year, ahead1.month, ahead1.day, 8,0,0,timezone)
		end

                # Monday last usa - Starts 3 days ago (Friday) at 8am (8); Ends 3 days ago (Friday) at 5pm (17)
                start_time_usa_last = Time.new(ago3.year, ago3.month, ago3.day, 8,0,0,timezone)
                end_time_usa_last = Time.new(ago3.year, ago3.month, ago3.day, 17,0,0,timezone)
                # Monday current usa - Starts today (Monday) at 8am (8); Ends today (Monday) at 5pm (17)
                start_time_usa_current = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
                end_time_usa_current = Time.new(now.year, now.month, now.day, 17,0,0,timezone)

                # Monday last evening - Starts 3 days ago (Friday) at 5pm (17); Ends 3 days ago (Friday) at 10pm (22)
                start_time_evening_last = Time.new(ago3.year, ago3.month, ago3.day, 17,0,0,timezone)
                end_time_evening_last = Time.new(ago3.year, ago3.month, ago3.day, 22,0,0,timezone)
                # Monday current evening - Starts today (Monday) at 5pm (17); Ends today (Monday) at 10pm (22)
                start_time_evening_current = Time.new(now.year, now.month, now.day, 17,0,0,timezone)
                end_time_evening_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)

		# if the day is Tuesday (2)
        elsif (day == 2) then
                # Tuesday last weekend - Starts 4 days ago (Friday) at 10pm (22); Ends 2 days ago (Sunday) at 10pm (22)
                start_time_weekend_last = Time.new(ago4.year, ago4.month, ago4.day, 22,0,0,timezone)
                end_time_weekend_last = Time.new(ago2.year, ago2.month, ago2.day, 22,0,0,timezone)
                # Tuesday current weekend - same start and end times since weekend is not included in the weekdays
                start_time_weekend_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
                end_time_weekend_current = start_time_weekend_current

                # Tuesday before 10pm - last day is Sunday-Monday; current day is Monday-Tuesday
                if (hour < 22) then
                	# Tuesday last euro - Starts 2 days ago (Sunday) at 10pm (22); Ends yesterday (Monday) at 8am (8)
                	start_time_euro_last = Time.new(ago2.year, ago2.month, ago2.day, 22,0,0,timezone)
                	end_time_euro_last = Time.new(ago1.year, ago1.month, ago1.day, 8,0,0,timezone)
			# Tuesday current euro - Starts 1 day ago (Monday) at 10pm (22); Ends today (Tuesday) at 8am (8)
			start_time_euro_current = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
			end_time_euro_current = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
		# Tuesday between 10-11:59pm - last is Monday-Tuesday; current is Tuesday-Wednesday
		else
			# Tuesday last euro - Starts 1 day ago (Monday) at 10pm (22); Ends today (Monday) at 8am (8)
                	start_time_euro_last = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                	end_time_euro_last = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
                	# Tuesday current euro - Starts today (Tuesday) at 10pm (22); Ends tomorrow (Wednesday) at 8am (8)
                	start_time_euro_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)
                	end_time_euro_current = Time.new(ahead1.year, ahead1.month, ahead1.day, 8,0,0,timezone)
		end

                # Tuesday last usa - Starts yesterday (Monday) at 8am (8); Ends yesterday (Monday) at 5pm (17)
                start_time_usa_last = Time.new(ago1.year, ago1.month, ago1.day, 8,0,0,timezone)
                end_time_usa_last = Time.new(ago1.year, ago1.month, ago1.day, 17,0,0,timezone)
                # Tuesday current usa - Starts today (Tuesday) at 8am (8); Ends today (Tuesday) at 5pm (17)
                start_time_usa_current = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
                end_time_usa_current = Time.new(now.year, now.month, now.day, 17,0,0,timezone)

                # Tuesday last evening - Starts yesterday (Monday) at 5pm (17); Ends yesterday (Monday) at 10pm (22)
                start_time_evening_last = Time.new(ago1.year, ago1.month, ago1.day, 17,0,0,timezone)
                end_time_evening_last = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                # Tuesday current evening - Starts today (Tuesday) at 5pm (17); Ends today (Tuesday) at 10pm (22)
                start_time_evening_current = Time.new(now.year, now.month, now.day, 17,0,0,timezone)
                end_time_evening_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)
		

		# if the day is Wednesday (3)
        elsif (day == 3) then
                # Wednesday last weekend - Starts 5 days ago (Friday) at 10pm (22); Ends 3 days ago (Sunday) at 10pm (22)
                start_time_weekend_last = Time.new(ago5.year, ago5.month, ago5.day, 22,0,0,timezone)
                end_time_weekend_last = Time.new(ago3.year, ago3.month, ago3.day, 22,0,0,timezone)
                # Wednesday current weekend - same start and end times since weekend is not included in the weekdays
		start_time_weekend_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)		
		end_time_weekend_current = start_time_weekend_current

                # Wednesday before 10pm - last day is Monday-Tuesday; current day is Tuesday-Wednesday
                if (hour < 22) then
                	# Wednesday last euro - Starts 2 days ago (Monday) at 10pm (22); Ends yesterday (Tuesday) at 8am (8)
                	start_time_euro_last = Time.new(ago2.year, ago2.month, ago2.day, 22,0,0,timezone)
                	end_time_euro_last = Time.new(ago1.year, ago1.month, ago1.day, 8,0,0,timezone)
			# Wednesday current euro - Starts 1 day ago (Tuesday) at 10pm (22); Ends today (Wednesday) at 8am (8)
			start_time_euro_current = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
			end_time_euro_current = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
		# Wednesday between 10-11:59pm - last is Tuesday-Wednesday; current is Wednesday-Thursday
		else
			# Wednesday last euro - Starts 1 day ago (Tuesday) at 10pm (22); Ends today (Wednesday) at 8am (8)
                	start_time_euro_last = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                	end_time_euro_last = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
                	# Wednesday current euro - Starts today (Wednesday) at 10pm (22); Ends tomorrow (Thursday) at 8am (8)
                	start_time_euro_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)
                	end_time_euro_current = Time.new(ahead1.year, ahead1.month, ahead1.day, 8,0,0,timezone)
		end

                # Wednesday last usa - Starts yesterday (Tuesday) at 8am (8); Ends yesterday (Tuesday) at 5pm (17)
                start_time_usa_last = Time.new(ago1.year, ago1.month, ago1.day, 8,0,0,timezone)
                end_time_usa_last = Time.new(ago1.year, ago1.month, ago1.day, 17,0,0,timezone)
                # Wednesday current usa - Starts today (Wednesday) at 8am (8); Ends today (Wednesday) at 5pm (17)
                start_time_usa_current = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
                end_time_usa_current = Time.new(now.year, now.month, now.day, 17,0,0,timezone)

                # Wednesday last evening - Starts yesterday (Tuesday) at 5pm (17); Ends yesterday (Tuesday) at 10pm (22)
                start_time_evening_last = Time.new(ago1.year, ago1.month, ago1.day, 17,0,0,timezone)
                end_time_evening_last = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                # Wednesday current evening - Starts today (Wednesday) at 5pm (17); Ends today (Wednesday) at 10pm (22)
                start_time_evening_current = Time.new(now.year, now.month, now.day, 17,0,0,timezone)
                end_time_evening_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)

		# if the day is Thursday (4)
        elsif (day == 4) then
                # Thursday last weekend - Starts 6 days ago (Friday) at 10pm (22); Ends 4 days ago (Sunday) at 10pm (22)
                start_time_weekend_last = Time.new(ago6.year, ago6.month, ago6.day, 22,0,0,timezone)
                end_time_weekend_last = Time.new(ago4.year, ago4.month, ago4.day, 22,0,0,timezone)
                # Thursday current weekend - same start and end times since weekend is not included in the weekdays
                start_time_weekend_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
                end_time_weekend_current = start_time_weekend_current

                # Thursday before 10pm - last day is Tuesday-Wednesday; current day is Wednesday-Thursday
                if (hour < 22) then
                	# Thursday last euro - Starts 2 days ago (Tuesday) at 10pm (22); Ends yesterday (Wednesday) at 8am (8)
                	start_time_euro_last = Time.new(ago2.year, ago2.month, ago2.day, 22,0,0,timezone)
                	end_time_euro_last = Time.new(ago1.year, ago1.month, ago1.day, 8,0,0,timezone)
			# Thursday current euro - Starts 1 day ago (Wednesday) at 10pm (22); Ends today (Thursday) at 8am (8)
			start_time_euro_current = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
			end_time_euro_current = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
		# Thursday between 10-11:59pm - last is Wednesday-Thursday; current is Thursday-Friday
		else
			# Thursday last euro - Starts 1 day ago (Wednesday) at 10pm (22); Ends today (Thursday) at 8am (8)
                	start_time_euro_last = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                	end_time_euro_last = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
                	# Thursday current euro - Starts today (Thursday) at 10pm (22); Ends tomorrow (Friday) at 8am (8)
                	start_time_euro_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)
                	end_time_euro_current = Time.new(ahead1.year, ahead1.month, ahead1.day, 8,0,0,timezone)
		end

                # Thursday last usa - Starts yesterday (Wednesday) at 8am (8); Ends yesterday (Wednesday) at 5pm (17)
                start_time_usa_last = Time.new(ago1.year, ago1.month, ago1.day, 8,0,0,timezone)
                end_time_usa_last = Time.new(ago1.year, ago1.month, ago1.day, 17,0,0,timezone)
                # Thursday current usa - Starts today (Thursday) at 8am (8); Ends today (Thursday) at 5pm (17)
                start_time_usa_current = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
                end_time_usa_current = Time.new(now.year, now.month, now.day, 17,0,0,timezone)

                # Thursday last evening - Starts yesterday (Wednesday) at 5pm (17); Ends yesterday (Wednesday) at 10pm (22)
                start_time_evening_last = Time.new(ago1.year, ago1.month, ago1.day, 17,0,0,timezone)
                end_time_evening_last = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                # Thursday current evening - Starts today (Thursday) at 5pm (17); Ends today (Thursday) at 10pm (22)
                start_time_evening_current = Time.new(now.year, now.month, now.day, 17,0,0,timezone)
                end_time_evening_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)

		# if the day is Friday (5)
        elsif (day == 5) then
                # Friday before 10pm - weekend: last is the previous weekend (7-5 days ago); current is 0
                # Friday before 10pm - euro: last day is Wednesday-Thursday; current day is Thursday-Friday
		if (hour < 22) then
			# Friday last weekend - Starts 7 days ago (Friday) at 10pm (22);  Ends 5 days ago (Sunday) at 10pm (22)
			start_time_weekend_last = Time.new(ago7.year, ago7.month, ago7.day, 22,0,0,timezone)
			end_time_weekend_last = Time.new(ago5.year, ago5.month, ago5.day, 22,0,0,timezone)
			# Friday current weekend - same start and end times since weekend is not included in the weekdays
	                start_time_weekend_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
	                end_time_weekend_current = start_time_weekend_current

                	# Friday last euro - Starts 2 days ago (Wednesday) at 10pm (22); Ends yesterday (Thursday) at 8am (8)
                	start_time_euro_last = Time.new(ago2.year, ago2.month, ago2.day, 22,0,0,timezone)
                	end_time_euro_last = Time.new(ago1.year, ago1.month, ago1.day, 8,0,0,timezone)
			# Friday current euro - Starts 1 day ago (Thursday) at 10pm (22); Ends today (Friday) at 8am (8)
			start_time_euro_current = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
			end_time_euro_current = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
              
                # Friday between 10-11:59pm - weekend: last is the previous weekend (7-5 days ago); current is today through 2 days from now
		# Friday between 10-11:59pm - euro: last is Thursday-Friday; current is 0
		else
			# Friday last weekend - Starts 7 days ago (Friday) at 10pm (22);  Ends 5 days ago (Sunday) at 10pm (22)
			start_time_weekend_last = Time.new(ago7.year, ago7.month, ago7.day, 22,0,0,timezone)
			end_time_weekend_last = Time.new(ago5.year, ago5.month, ago5.day, 22,0,0,timezone)
			# Friday current weekend - Starts today (Friday) at 10pm (22);  Ends 2 days from now (Sunday) at 10pm (22)
			start_time_weekend_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)
			end_time_weekend_current = Time.new(ahead2.year, ahead2.month, ahead2.day, 22,0,0,timezone)
					
			# Friday last euro - Starts 1 day ago (Thursday) at 10pm (22); Ends today (Friday) at 8am (8)
                	start_time_euro_last = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                	end_time_euro_last = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
                	# Friday current euro - same start and end times since euro is not included in the weekends
                	start_time_euro_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
                	end_time_euro_current = start_time_euro_current
		end

                # Friday last usa - Starts yesterday (Thursday) at 8am (8); Ends yesterday (Thursday) at 5pm (17)
                start_time_usa_last = Time.new(ago1.year, ago1.month, ago1.day, 8,0,0,timezone)
                end_time_usa_last = Time.new(ago1.year, ago1.month, ago1.day, 17,0,0,timezone)
                # Friday current usa - Starts today (Friday) at 8am (8); Ends today (Friday) at 5pm (17)
                start_time_usa_current = Time.new(now.year, now.month, now.day, 8,0,0,timezone)
                end_time_usa_current = Time.new(now.year, now.month, now.day, 17,0,0,timezone)

                # Friday last evening - Starts yesterday (Thursday) at 5pm (17); Ends yesterday (Thursday) at 10pm (22)
                start_time_evening_last = Time.new(ago1.year, ago1.month, ago1.day, 17,0,0,timezone)
                end_time_evening_last = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                # Friday current evening - Starts today (Friday) at 5pm (17); Ends today (Friday) at 10pm (22)
                start_time_evening_current = Time.new(now.year, now.month, now.day, 17,0,0,timezone)
                end_time_evening_current = Time.new(now.year, now.month, now.day, 22,0,0,timezone)
		
	

		# if the day is Saturday (6)
        elsif (day == 6) then
                # Saturday last weekend - Starts 8 days ago (Friday) at 10pm (22); Ends 6 days ago (Sunday) at 10pm (22)
                start_time_weekend_last = Time.new(ago8.year, ago8.month, ago8.day, 22,0,0,timezone)
                end_time_weekend_last = Time.new(ago6.year, ago6.month, ago6.day, 22,0,0,timezone)
                # Saturday current weekend - Starts yesterday (Friday) at 10pm (22);  Ends 1 day from now (Sunday) at 10pm (22)
                start_time_weekend_current = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
		end_time_weekend_current = Time.new(ahead1.year, ahead1.month, ahead1.day, 22,0,0,timezone)
       
		# Saturday last euro - Starts 2 days ago (Thursday) at 10pm (22); Ends yesterday (Friday) at 8am (8)
		start_time_euro_last = Time.new(ago2.year, ago2.month, ago2.day, 22,0,0,timezone)
		end_time_euro_last = Time.new(ago1.year, ago1.month, ago1.day, 8,0,0,timezone)
		# Saturday current euro - same start and end times since euro is not included in the weekends
		start_time_euro_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
		end_time_euro_current = start_time_euro_current

                # Saturday last usa - Starts yesterday (Friday) at 8am (8); Ends yesterday (Friday) at 5pm (17)
                start_time_usa_last = Time.new(ago1.year, ago1.month, ago1.day, 8,0,0,timezone)
                end_time_usa_last = Time.new(ago1.year, ago1.month, ago1.day, 17,0,0,timezone)
                # Saturday current usa - same start and end times since usa is not included in the weekends
                start_time_usa_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
                end_time_usa_current = start_time_usa_current

                # Saturday last evening - Starts yesterday (Friday) at 5pm (17); Ends yesterday (Friday) at 10pm (22)
                start_time_evening_last = Time.new(ago1.year, ago1.month, ago1.day, 17,0,0,timezone)
                end_time_evening_last = Time.new(ago1.year, ago1.month, ago1.day, 22,0,0,timezone)
                # Saturday current evening - same start and end times since evening is not included in the weekends
                start_time_evening_current = Time.new(now.year, now.month, now.day, now.hour,now.min,now.sec,timezone)
                end_time_evening_current = start_time_evening_current
        
        end

	start_time_prior_euro = start_time_euro_last
	end_time_prior_euro = end_time_euro_last
	start_time_prior_usa = start_time_usa_last
	end_time_prior_usa = end_time_usa_last
	start_time_prior_evening = start_time_evening_last
	end_time_prior_evening = end_time_evening_last

        start_time_euro = start_time_euro_current
        end_time_euro = end_time_euro_current
        start_time_usa = start_time_usa_current
        end_time_usa = end_time_usa_current
        start_time_evening = start_time_evening_current
        end_time_evening = end_time_evening_current

=begin
if time.wday == 1
        start_time_prior_euro = Time.new(Time.now.year,Time.now.month,Time.now.day, 22,0,0, "-07:00") - 4.days
        end_time_prior_euro = Time.new(Time.now.year,Time.now.month,Time.now.day, 8,0,0, "-07:00") - 3.days
        start_time_prior_usa = Time.new(Time.now.year,Time.now.month,Time.now.day, 8,0,0, "-07:00") - 3.days
        end_time_prior_usa = Time.new(Time.now.year,Time.now.month,Time.now.day, 15,    0,0, "-07:00") - 3.days
        start_time_prior_evening = Time.new(Time.now.year,Time.now.month,Time.now.day, 17,0,0, "-07:00") - 3.days
        end_time_prior_evening = Time.new(Time.now.year,Time.now.month,Time.now.day,    22,0,0, "-07:00") - 3.days

  else
        start_time_prior_euro = Time.new(Time.now.year,Time.now.month,Time.now.day, 22,0,0, "-07:00") - 2.days
        end_time_prior_euro = Time.new(Time.now.year,Time.now.month,Time.now.day, 8,0,0, "-07:00").yesterday
        start_time_prior_usa = Time.new(Time.now.year,Time.now.month,Time.now.day, 8,0,0, "-07:00").yesterday
        end_time_prior_usa = Time.new(Time.now.year,Time.now.month,Time.now.day, 15,0,0, "-07:00").yesterday
        start_time_prior_evening = Time.new(Time.now.year,Time.now.month,Time.now.day, 17,0,0, "-07:00").yesterday
        end_time_prior_evening = Time.new(Time.now.year,Time.now.month,Time.now.day, 22,0,0, "-07:00").yesterday

   end
=end
	groups = ['Support']
	tag_ids = ['%claimed%','%keep_open%','%billing%','%live_chat%','%permaopen%']

	previous = ['new','open']
	previous_new = ['new']
	current = ['pending','solved']



	@euro_current_new_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_euro}.where{created_at < end_time_euro}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update <= 60}.count

	@euro_current_new_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_euro}.where{created_at < end_time_euro}.where{previous_status.like_any previous_new}.where{current_status.like_any current}.where{time_since_requester_update > 60}.count
	
	@euro_prior_new_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_euro}.where{created_at < end_time_prior_euro}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update <= 60}.count

 	@euro_prior_new_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_euro}.where{created_at < end_time_prior_euro}.where{previous_status.like_any previous_new}.where{current_status.like_any current}.where{time_since_requester_update > 60}.count

	@euro_current_aging_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_euro}.where{created_at < end_time_euro}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update >= 60}.where{time_since_requester_update <= 120}.count

	@euro_current_aging_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_euro}.where{created_at < end_time_euro}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update > 120}.count

	@euro_prior_aging_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_euro}.where{created_at < end_time_prior_euro}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update >= 60}.where{time_since_requester_update <= 120}.count

	@euro_prior_aging_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_euro}.where{created_at < end_time_prior_euro}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update > 120}.count

	@usa_current_new_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_usa}.where{created_at < end_time_usa}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update <= 60}.count
	
	@usa_current_new_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_usa}.where{created_at < end_time_usa}.where{previous_status.like_any previous_new}.where{current_status.like_any current}.where{time_since_requester_update > 60}.count
	
	@usa_prior_new_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_usa}.where{created_at < end_time_prior_usa}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update <= 60}.count

	@usa_prior_new_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_usa}.where{created_at < end_time_prior_usa}.where{previous_status.like_any previous_new}.where{current_status.like_any current}.where{time_since_requester_update > 60}.count


	@usa_current_aging_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_usa}.where{created_at < end_time_usa}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update >= 60}.where{time_since_requester_update <= 120}.count
	
	@usa_current_aging_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_usa}.where{created_at < end_time_usa}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update > 120}.count

	@usa_prior_aging_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_usa}.where{created_at < end_time_prior_usa}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update >= 60}.where{time_since_requester_update <= 120}.count

        @usa_prior_aging_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_usa}.where{created_at < end_time_prior_usa}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update > 120}.
count

	@evening_current_new_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_evening}.where{created_at < end_time_evening}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update <= 60}.count

	@evening_prior_new_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_evening}.where{created_at < end_time_prior_evening}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update <= 60}.count
	
	@evening_prior_new_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_evening}.where{created_at < end_time_prior_evening}.where{previous_status.like_any previous_new}.where{current_status.like_any current}.where{time_since_requester_update > 60}.count
	

        @evening_current_new_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_evening}.where{created_at < end_time_evening}.where{previous_status.like_any previous_new}.where{current_status.like_any current}.where{time_since_requester_update > 60}.count
	
	@evening_current_aging_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_evening}.where{created_at < end_time_evening}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update >= 60}.where{time_since_requester_update <= 120}.count
	
	
	@evening_prior_aging_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_evening}.where{created_at < end_time_prior_evening}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update >= 60}.where{time_since_requester_update <= 120}.count

	@evening_current_aging_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_evening}.where{created_at < end_time_evening}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update > 120}.count

	@evening_prior_aging_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_evening}.where{created_at < end_time_prior_evening}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update > 120}.count

	@euro_current_new_total = @euro_current_new_met + @euro_current_new_violation
	if (@euro_current_new_total == 0) then
		@euro_current_new_percentage = 0
	else
		@euro_current_new_percentage = (@euro_current_new_met.to_f/@euro_current_new_total.to_f) * 100
	end

	@euro_current_aging_total = @euro_current_aging_met + @euro_current_aging_violation
        if (@euro_current_aging_total == 0) then
                @euro_current_aging_percentage = 0
        else
                @euro_current_aging_percentage = (@euro_current_aging_met.to_f/@euro_current_aging_total.to_f) * 100
        end


	@usa_current_new_total = @usa_current_new_met + @usa_current_new_violation
	if (@usa_current_new_total == 0) then
		@usa_current_new_percentage = 0
	else
		@usa_current_new_percentage = (@usa_current_new_met.to_f/@usa_current_new_total.to_f) * 100
	end

	@usa_current_aging_total = @usa_current_aging_met + @usa_current_aging_violation
        if (@usa_current_aging_total == 0) then
                @usa_current_aging_percentage = 0
        else
                @usa_current_aging_percentage = (@usa_current_aging_met.to_f/@usa_current_aging_total.to_f) * 100
        end

        @evening_current_new_total = @evening_current_new_met + @evening_current_new_violation
        if (@evening_current_new_total == 0) then
		@evening_current_new_percentage = 0
	else 
		@evening_current_new_percentage = (@evening_current_new_met.to_f/@evening_current_new_total.to_f) * 100	
	end

	@evening_current_aging_total = @evening_current_aging_met + @evening_current_aging_violation
        if (@evening_current_aging_total == 0) then
                @evening_current_aging_percentage = 0
        else
                @evening_current_aging_percentage = (@evening_current_aging_met.to_f/@evening_current_aging_total.to_f) * 100
        end

	@euro_prior_new_total = @euro_prior_new_met + @euro_prior_new_violation
        if (@euro_prior_new_total == 0) then
                @euro_prior_new_percentage = 0
        else
                @euro_prior_new_percentage = (@euro_prior_new_met.to_f/@euro_prior_new_total.to_f) * 100
        end

        @euro_prior_aging_total = @euro_prior_aging_met + @euro_prior_aging_violation
        if (@euro_prior_aging_total == 0) then
                @euro_prior_aging_percentage = 0
        else
                @euro_prior_aging_percentage = (@euro_prior_aging_met.to_f/@euro_prior_aging_total.to_f) * 100
        end


        @usa_prior_new_total = @usa_prior_new_met + @usa_prior_new_violation
        if (@usa_prior_new_total == 0) then
                @usa_prior_new_percentage = 0
        else
                @usa_prior_new_percentage = (@usa_prior_new_met.to_f/@usa_prior_new_total.to_f) * 100
        end

        @usa_prior_aging_total = @usa_prior_aging_met + @usa_prior_aging_violation
        if (@usa_prior_aging_total == 0) then
                @usa_prior_aging_percentage = 0
        else
                @usa_prior_aging_percentage = (@usa_prior_aging_met.to_f/@usa_prior_aging_total.to_f) * 100
        end

        @evening_prior_new_total = @evening_prior_new_met + @evening_prior_new_violation
        if (@evening_prior_new_total == 0) then
                @evening_prior_new_percentage = 0
        else
                @evening_prior_new_percentage = (@evening_prior_new_met.to_f/@evening_prior_new_total.to_f) * 100
        end

        @evening_prior_aging_total = @evening_prior_aging_met + @evening_prior_aging_violation
        if (@evening_prior_aging_total == 0) then
                @evening_prior_aging_percentage = 0
        else
                @evening_prior_aging_percentage = (@evening_prior_aging_met.to_f/@evening_prior_aging_total.to_f) * 100
        end


#weekend
=begin
require 'date'

myTime = Time.new

case myTime.wday
when 0
 myModifier = -2
when 1
 myModifier = -3
when 2
 myModifier = -4
when 3
 myModifier = -5
when 4
 myModifier = -6
when 5
 myModifier = -7
when 6
 myModifier = -1
end


start_time_weekend = Time.new(Time.now.year,Time.now.month,(Time.now.day + myModifier), 22,0,0, "-07:00")
end_time_weekend = Time.new(Time.now.year,Time.now.month,(Time.now.day + (myModifier + 2)), 22,0,0, "-07:00")

start_time_prior_weekend =  Time.new(Time.now.year,Time.now.month,(Time.now.day + myModifier), 22,0,0, "-07:00") - 7.days
end_time_prior_weekend = Time.new(Time.now.year,Time.now.month,(Time.now.day + (myModifier + 2)), 22,0,0, "-07:00") - 7.days
=end

start_time_weekend = start_time_weekend_current
end_time_weekend = end_time_weekend_current

start_time_prior_weekend = start_time_weekend_last
end_time_prior_weekend = end_time_weekend_last

@weekend_current_new_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_weekend}.where{created_at < end_time_weekend}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update <= 60}.count

@weekend_current_new_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_weekend}.where{created_at < end_time_weekend}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update > 60}.count

@weekend_prior_new_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_weekend}.where{created_at < end_time_prior_weekend}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update <= 60}.count

@weekend_prior_new_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_weekend}.where{created_at < end_time_prior_weekend}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update > 60}.count

@weekend_current_aging_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_weekend}.where{created_at < end_time_weekend}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update >= 60}.where{time_since_requester_update <= 120}.count

@weekend_current_aging_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_weekend}.where{created_at < end_time_weekend}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update > 120}.count

@weekend_prior_aging_met = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_weekend}.where{created_at < end_time_prior_weekend}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update >= 60}.where{time_since_requester_update <= 120}.count

@weekend_prior_aging_violation = AuditEvent.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time_prior_weekend}.where{created_at < end_time_prior_weekend}.where{previous_status.like_any previous}.where{current_status.like_any current}.where{time_since_requester_update > 120}.count

@weekend_current_new_total = @weekend_current_new_met + @weekend_current_new_violation
        if (@weekend_current_new_total == 0) then
                @weekend_current_new_percentage = 0
        else
                @weekend_current_new_percentage = (@weekend_current_new_met.to_f/@weekend_current_new_total.to_f) * 100
        end

        @weekend_current_aging_total = @weekend_current_aging_met + @weekend_current_aging_violation
        if (@weekend_current_aging_total == 0) then
                @weekend_current_aging_percentage = 0
        else
                @weekend_current_aging_percentage = (@weekend_current_aging_met.to_f/@weekend_current_aging_total.to_f) * 100
        end

@weekend_prior_new_total = @weekend_prior_new_met + @weekend_prior_new_violation
        if (@weekend_prior_new_total == 0) then
                @weekend_prior_new_percentage = 0
        else
                @weekend_prior_new_percentage = (@weekend_prior_new_met.to_f/@weekend_prior_new_total.to_f) * 100
        end

        @weekend_prior_aging_total = @weekend_prior_aging_met + @weekend_prior_aging_violation
        if (@weekend_prior_aging_total == 0) then
                @weekend_prior_aging_percentage = 0
        else
                @weekend_prior_aging_percentage = (@weekend_prior_aging_met.to_f/@weekend_prior_aging_total.to_f) * 100
        end



	@display = waiting_tickets_last_events_aging.sort_by{ |k| -k["time_since_requester_update"] }
	@profile = current_profile


  end

  def update
 	@profile = Profile.find(params[:id])
 	if @profile.update_attributes(params[:profile])
      flash[:notice] = "Successfully updated product."
    end
 	
  	redirect_to :back
  end
end
