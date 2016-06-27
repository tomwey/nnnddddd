class Payout < ActiveRecord::Base
  belongs_to :user
  
  validates :money, :card_no, :card_name, :user_id, presence: true
  validates_uniqueness_of :card_no
  
  after_create :record_pay_history
  def record_pay_history
    user.balance -= money
    user.balance = 0 if user.balance < 0
    user.save!
    
    # 记录交易明细
    PayHistory.create!(pay_name: '提现', 
                       pay_type: PayHistory::PAY_TYPE_PAY_OUT, 
                       money: money,
                       user_id: user.id)
  end
  
  def pay!
    self.payed_at = Time.now
    self.save!
  end
  
end
