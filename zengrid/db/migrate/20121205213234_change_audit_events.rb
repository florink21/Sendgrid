class ChangeAuditEvents < ActiveRecord::Migration
  def change
  	change_table :audit_events do |t|
  		t.remove :change_of_status
  		t.integer :time_since_requester_update
  		t.integer :time_since_agent_update
	end
  end
end
