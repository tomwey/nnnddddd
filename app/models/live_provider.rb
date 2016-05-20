class LiveProvider < ActiveRecord::Base
  validates :rtmp_push_url, presence: true
end
