class PayHistory < ActiveRecord::Base
  belongs_to :user
  
  PAY_TYPE_PAY_IN  = 0 # 充值
  PAY_TYPE_PAY_OUT = 1 # 提现
  PAY_TYPE_GRANT   = 2 # 打赏
end
