class Grant < ActiveRecord::Base
  validates :from, :money, presence: true
  validates_numericality_of :money, greater_than_or_equal_to: 0.01
  
  belongs_to :granting_user, class_name: 'User', foreign_key: 'from'
  belongs_to :granted_user,  class_name: 'User', foreign_key: 'to'
end
