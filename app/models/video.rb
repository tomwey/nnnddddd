class Video < ActiveRecord::Base
  validates :title, :file, :category_id, presence: true
  
  belongs_to :user
  belongs_to :category
  has_many :likes, as: :likeable
  
  mount_uploader :file, VideoUploader
  
  scope :sorted, -> { order('sort desc') }
  scope :recent, -> { order('id desc') }
  scope :hot,    -> { order('view_count desc') }
  scope :from_live, -> { where(from_live: true) }
  scope :no_from_live, -> { where(from_live: false) }
  
  before_create :generate_stream_id
  def generate_stream_id
    self.stream_id = SecureRandom.uuid.gsub('-', '') if self.stream_id.blank?
  end
  
  def type
    2
  end
end
