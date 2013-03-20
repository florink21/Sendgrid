class Profile < ActiveRecord::Base
  attr_accessible :group_backend, :group_billing, :group_compliance, :group_desktop_support, :group_dev_relations, :group_escalation, :group_frontend, :group_hp, :group_marketing, :group_qa_admins, :group_sales, :group_support, :group_z99_alert, :group_z99_everyone, :group_z99_reseller
  attr_accessible :channel_api, :channel_email, :channel_system, :channel_web
  attr_accessible :tag_live_chat, :tag_email, :tag_claimed, :tag_keep_open, :tag_billing, :tag_quiet
  attr_accessible :status_new, :status_open, :status_pending, :status_solved, :status_closed 
  attr_accessible :last_event_only, :events_with_change_in_status_or_last_only,  :time_since_requester_update_threshold
  belongs_to :user
end

