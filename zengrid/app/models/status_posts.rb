class StatusPosts < ActiveRecord::Base
  attr_accessible :body, :caption, :timestamp
end
