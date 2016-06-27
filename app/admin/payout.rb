ActiveAdmin.register Payout do

menu priority: 6

actions :index

index do
  selectable_column
  column :id
  column '用户', sortable: false do |ph|
    ph.user.try(:nickname) || ph.user.try(:mobile)
  end
  column :card_name, sortable: false
  column :card_no, sortable: false
  column :money
  column '是否支付', sortable: false do |payout|
    payout.payed_at.blank? ? '否' : '是'
  end
  column('确认支付时间', :payed_at)
  column('申请时间', :created_at)
  actions defaults: false do |payout|
    if payout.payed_at.blank?
      item '确认支付', pay_admin_payout_path(payout), method: :put
    end
  end
end

member_action :pay, method: :put do
  resource.pay!
  redirect_to admin_payouts_path, notice: "已经确认支付"
end


end
