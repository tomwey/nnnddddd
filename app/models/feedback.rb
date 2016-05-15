class Feedback < ActiveRecord::Base
  validates :content, presence: true
end
