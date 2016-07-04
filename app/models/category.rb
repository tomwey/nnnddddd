class Category < ActiveRecord::Base
  validates :name, presence: true
  mount_uploader :icon, CategoryIconUploader
  
  scope :sorted, -> { order('sort desc') }
  scope :recent, -> { order('id desc') }
  scope :opened, -> { where(opened: true) }
  scope :no_delete, -> { where(visible: true) }
  
  default_scope -> { where(visible: true) }
  
  def self.current_user_upload
    Category.no_delete.opened.where(user_upload: true).order('id desc').first
  end
  
  def open!
    self.opened = true
    self.save!
  end
  
  def close!
    self.opened = false
    self.save!
  end
  
  def delete!
    self.visible = false
    self.save!
  end
  
end
