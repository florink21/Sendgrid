class AddOutageColumnToStatusPosts < ActiveRecord::Migration
  def change
    change_table :status_posts do |t|
      t.integer :outage
    end
  end
end
