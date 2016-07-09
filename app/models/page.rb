class Page < ActiveRecord::Base
  validates :title, :slug, :body, presence: true
  validates_uniqueness_of :slug
end
