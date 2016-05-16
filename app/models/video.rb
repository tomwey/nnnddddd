class Video < ActiveRecord::Base
  validates :title, :file, :category_id, presence: true
  
  belongs_to :user
  belongs_to :category
  has_many :likes, as: :likeable
  
  mount_uploader :file, VideoUploader
  
  scope :sorted, -> { order('sort desc') }
  scope :recent, -> { order('id desc') }
  scope :hot,    -> { order('view_count desc') }
end
