class CreateAuditEvents < ActiveRecord::Migration
  def change
    create_table :audit_events do |t|
      t.integer :ticket_id
      t.datetime :created_at
      t.text :channel
      t.text :group
      t.text :agent
      t.text :previous_status
      t.text :current_status
      t.integer :change_of_status
      t.text :subject
      t.text :tags
      t.text :shift
      t.text :team # not used initially
      t.boolean :last

      t.timestamps
    end
  end
end
