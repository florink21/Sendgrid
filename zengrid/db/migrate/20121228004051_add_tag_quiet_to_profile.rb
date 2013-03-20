class AddTagQuietToProfile < ActiveRecord::Migration
  def change
  	change_table :profiles do |t|
  		t.boolean :tag_quiet, :default => false
  	end
  end
end
