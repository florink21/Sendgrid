class AddFieldsToAuditEvent < ActiveRecord::Migration
  def change
    add_column :audit_events, :username, :text
    add_column :audit_events, :category, :text
    add_column :audit_events, :package, :text
  end
end
