class AuditEvent < ActiveRecord::Base
  attr_accessible :agent, :change_of_status, :channel, :created_at, :group, :previous_status, :current_status, :subject, :tags, :ticket_id


  # use lambda symbol -> for all scopes - not using lambda will be deprecated in Rails 4 - http://railscasts.com/episodes/355
  scope :include_groups, ->(current_user_groups) { where(:group_name => current_user_groups) } 
  scope :last_event, ->{ where(:last => true) }
  scope :one_hour_old, ->{ where("time_since_requester_update > ?", 60) }

  def self.support_sla(start_time, barebones=0)
    # added "barebones" parameter w/ default of 0 to get only the New and Aging SLA Percentage (used for Dashboard)

    groups = ['Support']
    tag_ids = ['%claimed%','%keep_open%','%billing%','%live_chat%','%permaopen%']
    previous = ['new','open']
    current = ['pending','solved']
 
    hash = self.where{group_name.like groups}.where{tags.not_like_all tag_ids}.where{created_at > start_time}.where{previous_status.like_any previous}.where{current_status.like_any current}.select("previous_status, time_since_requester_update")

    new_sla_met = 0
    new_sla_not_met = 0
    open_sla_met = 0
    open_sla_not_met = 0
    aging_sla_met = 0
    aging_sla_not_met = 0

    hash.each do |t|
      new_sla_met       +=1 if t.previous_status == "new"  && t.time_since_requester_update <= 60
      new_sla_not_met   +=1 if t.previous_status == "new"  && t.time_since_requester_update > 60
      open_sla_met      +=1 if t.previous_status == "open"  && t.time_since_requester_update <= 60
      open_sla_not_met  +=1 if t.previous_status == "open"  && t.time_since_requester_update > 60
      aging_sla_met     +=1 if t.time_since_requester_update > 60 && t.time_since_requester_update <= 120
      aging_sla_not_met +=1 if t.time_since_requester_update > 120
    end

    new_sla_percentage = case
      when (new_sla_met + new_sla_not_met) != 0 then (new_sla_met.to_f/(new_sla_met + new_sla_not_met) * 100).round
      when new_sla_met == 0 && new_sla_not_met == 0 then 100
      else 0
    end

    open_sla_percentage = case
      when (open_sla_met + open_sla_not_met) != 0 then (open_sla_met.to_f/(open_sla_met + open_sla_not_met) * 100).round
      when open_sla_met == 0 && open_sla_not_met == 0 then 100
      else 0
    end

    aging_sla_percentage = case
      when (aging_sla_met + aging_sla_not_met) != 0 then (aging_sla_met.to_f/(aging_sla_met + aging_sla_not_met) * 100).round
      when aging_sla_met == 0 && aging_sla_not_met == 0 then 100
      else 0
    end

    if barebones == 0
      return {new_sla_met: new_sla_met, new_sla_not_met: new_sla_not_met, new_sla_percentage: new_sla_percentage, open_sla_met: open_sla_met, open_sla_not_met: open_sla_not_met, open_sla_percentage: open_sla_percentage, aging_sla_met: aging_sla_met, aging_sla_not_met: aging_sla_not_met, aging_sla_percentage: aging_sla_percentage}
    else
      return {new_sla_percentage: new_sla_percentage, aging_sla_percentage: aging_sla_percentage}
    end

  end
end
