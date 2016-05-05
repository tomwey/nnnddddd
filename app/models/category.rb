class Category < ActiveRecord::Base
  validates :name, presence: true
  mount_uploader :icon, CategoryIconUploader
  
  scope :sorted, -> { order('sort desc') }
  scope :recent, -> { order('id desc') }
end
