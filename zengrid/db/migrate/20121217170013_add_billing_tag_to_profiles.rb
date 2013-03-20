class AddBillingTagToProfiles < ActiveRecord::Migration
  def change
  	change_table :profiles do |t|
  		t.boolean :tag_billing, :default => false
  	end
  end
end
