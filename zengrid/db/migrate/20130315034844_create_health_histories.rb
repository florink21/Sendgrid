class CreateHealthHistories < ActiveRecord::Migration
  def up
    create_table :health_histories do |t|
      t.integer :daypart
      t.integer :health

      t.timestamps
    end
  end

  def down
    drop_table :health_histories
  end
end
