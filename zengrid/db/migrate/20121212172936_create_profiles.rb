class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user

      t.boolean :group_backend, :default => false
      t.boolean :group_billing, :default => false
      t.boolean :group_compliance, :default => false
      t.boolean :group_desktop_support, :default => false
      t.boolean :group_dev_relations, :default => false
      t.boolean :group_escalation, :default => false
      t.boolean :group_frontend, :default => false
      t.boolean :group_hp, :default => false
      t.boolean :group_marketing, :default => false
      t.boolean :group_qa_admins, :default => false
      t.boolean :group_sales, :default => false
      t.boolean :group_support, :default => true
      t.boolean :group_z99_alert, :default => false
      t.boolean :group_z99_everyone, :default => false
      t.boolean :group_z99_reseller, :default => false

      t.boolean :channel_api, :default => true
      t.boolean :channel_email, :default => true
      t.boolean :channel_system, :default => true
      t.boolean :channel_web, :default => true

      t.boolean :tag_live_chat, :default => false
      t.boolean :tag_email, :default => true
      t.boolean :tag_claimed, :default => false
      t.boolean :tag_keep_open, :default => false

      t.boolean :status_new, :default => true
      t.boolean :status_open, :default => true
      t.boolean :status_pending, :default => false
      t.boolean :status_solved, :default => false
      t.boolean :status_closed, :default => false

      t.boolean :last_event_only, :default => false
      t.boolean :events_with_change_in_status_or_last_only, :default => true

      t.integer :time_since_requester_update_threshold, :default => 120

      t.timestamps
    end
  end
end
