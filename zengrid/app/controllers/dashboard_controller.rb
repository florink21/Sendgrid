include ActionView::Helpers::NumberHelper
include ZendeskStatsHelper
include ZengridStatsHelper
include SnapengageStatsHelper
include ShoretelStatsHelper
include SendgridStatsHelper
include ProvisionStatsHelper

class DashboardController < ApplicationController
  def index
    # Setup local variables
    nth_units = {:unit => "", :thousand => "K", :million => "M", :billion => "B", :trillion => "T", :quadrillion => "Q"}

    # Pull in the tickets from ZendeskStatsHelper getNewTickets[count|newurgent] and getAgingTickets[count|agingurgent]
    myNewTickets = ZendeskStatsHelper.get_new_tickets
    myAgingTickets = ZendeskStatsHelper.get_aging_tickets

    if myNewTickets["newurgent"] == 1
      newurgent_css = "major_new_tickets_hv_visible"
    else
      newurgent_css = "major_new_tickets_hv_hidden"
    end

    if myAgingTickets["agingurgent"] == 1
      agingurgent_css = "major_aging_tickets_hv_visible"
    else
      agingurgent_css = "major_aging_tickets_hv_hidden"
    end

    # Setup a default stack of numbers for testing purposes.
    # All of these numbers will come from actual database or API/local calls (sourced from the helpers included above)
    @stat_health = 100
    @stat_health_status = 1

    @stat_new_tickets = myNewTickets["count"]
    @stat_new_tickets_status = 1
    @stat_new_urgent_tickets = newurgent_css

    @stat_aging_tickets = myAgingTickets["count"]
    @stat_aging_tickets_status = 1
    @stat_aging_urgent_tickets = agingurgent_css

    @stat_active_chats = SnapengageStatsHelper.get_active_chats
    @stat_active_chats_status = 3

    @stat_active_calls = ShoretelStatsHelper.get_active_calls
    @stat_active_calls_status = 2

    @stat_agents_on_chats = SnapengageStatsHelper.get_active_agents

    @stat_emails_sent = number_to_human(SendgridStatsHelper.get_emails_sent, :precision => 2, :units => nth_units )
    @stat_kamta_queue = number_to_human(SendgridStatsHelper.get_kamta,     :precision => 2, :units => nth_units )
    @stat_provisioned_users = ProvisionStatsHelper.get_provisioned_users
    @stat_awaiting_provisioning = ProvisionStatsHelper.get_awaiting_provisioning
    @stat_sla_new_tickets = number_to_percentage(ZengridStatsHelper.get_new_sla, :precision => 0)
    @stat_sla_aging_tickets = number_to_percentage(ZengridStatsHelper.get_aging_sla, :precision => 0)

    # Test data for now, but later...
    # Call out to model to get the past 24 hours worth of hourly data, limiting to the most recent 24 entries
    @data_health = '[[98, "5pm"],[84, "6pm"],[87, "7pm"],[90, "8pm"],[96, "9pm"],[94, "10pm"],[91, "11pm"],[99, "12am"],[96, "1am"],[94, "2am"],[89, "3am"],[81, "4am"],[85, "5am"],[78, "6am"],[81, "7am"],[86, "8am"],[93, "9am"],[91, "10am"],[87, "11am"],[81, "12pm"],[76, "1pm"],[89, "2pm"],[92, "3pm"],[90,"4pm"]]'


    # call out to model to get the past 24 hours worth of posts, limiting to the most recent 4
    @arrStatusPosts = Array.new
    recentPosts = StatusPosts.find(:all, :order => "id desc", :limit => 4)
    recentPosts.each do |p|
       tmpHash = Hash.new
       tmpHash = {
         :caption => p.caption,
         :body => p.body,
         :timestamp => p.timestamp,
         :outage => p.outage
       }
       @arrStatusPosts.push tmpHash
     end

  end
end
