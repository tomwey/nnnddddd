class Bilibili < ActiveRecord::Base
  validates :content, :stream_id, presence: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  
  def author_name
    if author_id.blank?
      return '游客'
    else
      return author.nickname || author.hack_mobile
    end
  end
end
