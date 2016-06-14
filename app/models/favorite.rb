class Favorite < ActiveRecord::Base
  belongs_to :favoriteable, polymorphic: true, counter_cache: true
  belongs_to :user
end
