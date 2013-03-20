class CreateStatusPosts < ActiveRecord::Migration
  def up
    create_table :status_posts do |t|
      t.string :caption
      t.text :body
      t.datetime :timestamp

      t.timestamps
    end
  end

  def down
    drop_table :status_posts
  end
end
