# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#u = User.new
#u.email = 'admin@example.com'
#u.password = 'ChangeMe'
#u.confirmation_sent_at = Time.now
#u.confirmed_at = Time.now
#u.current_sign_in_at = Time.now
#u.save!(:validate => false)

#p = Profile.new
#p.user_id = u.id
#p.save!(:validate => false)

#user_signed_in = false

# Load seed data for StatusPosts
p = StatusPosts.new
p.caption = "First Post!"
p.body = "Test data - This is a regular post with nothing indicating that an outage is occuring. "
p.timestamp = Time.now
p.outage = 0
p.save!(:validate => false)

p = StatusPosts.new
p.caption = "Outage - Customers unable to log onto website"
p.body = "This is an example of an outage that's posted on status.sendgrid.com."
p.timestamp = Time.now
p.outage = 1
p.save!(:validate => false)

p = StatusPosts.new
p.caption = "OUTAGE - Something bad happened"
p.body = "This could be an email from pm@sendgrid.com with regards to an actual Outage (from the outage form)"
p.timestamp = Time.now
p.outage = 1
p.save!(:validate => false) 

p = StatusPosts.new
p.caption = "Billing run completed"
p.body = "If Billing wanted to have something pop up on the dashboard, then they could email into our ParseAPI address to make it happen."
p.timestamp = Time.now
p.outage = 0
p.save!(:validate => false) 

p = StatusPosts.new
p.caption = "5th post!"
p.body = "This post should push the post, titled 'First Post!' off the screen, since we only show 4 posts at a time"
p.timestamp = Time.now
p.outage = 0
p.save!(:validate => false) 

