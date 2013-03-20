class RenameGroupInAuditEvents < ActiveRecord::Migration
  def change
  	change_table :audit_events do |t|
  		t.rename :group, :group_name
  	end
  end
end
