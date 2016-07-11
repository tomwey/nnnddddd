ActiveAdmin.register User do

menu priority: 2, label: '用户'

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :balance
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

controller do
  def update
    money = params[:user][:money].to_f
    resource.balance += money
    
    if resource.save
      # 记录交易明细
      PayHistory.create!(pay_name: '充值', 
                         pay_type: PayHistory::PAY_TYPE_PAY_IN, 
                         money: money,
                         user_id: resource.id)
                         
      redirect_to admin_users_path
    else
      render :edit
    end
  end
end

actions :index, :edit, :update

filter :nickname
filter :mobile
filter :private_token
filter :created_at

scope 'all', default: true do |users|
  users.no_delete
end

scope '正常用户', :verified do |users|
  users.no_delete.verified
end

index do
  selectable_column
  column :id
  column :nickname, sortable: false
  column :avatar, sortable: false do |u|
    u.avatar.blank? ? image_tag('avatar/large.png', size: '30x30') : image_tag(u.avatar.url(:large), size: '30x30')
  end
  column :mobile, sortable: false
  # column 'Token', sortable: false do |u|
  #   u.private_token
  # end
  column '余额' do |u|
    u.balance
  end
  column '打赏' do |u|
    raw("打赏别人：#{u.sent_money}元<br>收到打赏：#{u.receipt_money}元")
  end
  column :verified, sortable: false
  column :created_at
  
  actions defaults: false do |u|
    if u.verified
      item "禁用", block_admin_user_path(u), method: :put
    else
      item "启用", unblock_admin_user_path(u), method: :put
    end
    item " 充值", edit_admin_user_path(u)
  end
end

# 批量禁用账号
batch_action :block do |ids|
  batch_action_collection.find(ids).each do |user|
    user.block!
  end
  redirect_to collection_path, alert: "已经禁用"
end

# 批量启用账号
batch_action :unblock do |ids|
  batch_action_collection.find(ids).each do |user|
    user.unblock!
  end
  redirect_to collection_path, alert: "已经启用"
end

member_action :block, method: :put do
  resource.block!
  redirect_to admin_users_path, notice: "已禁用"
end

member_action :unblock, method: :put do
  resource.unblock!
  redirect_to admin_users_path, notice: "取消禁用"
end

# member_action :pay_in, label: '充值', method: [:get, :put] do
#   if request.put?
#     resource.balance += params[:money]
#     resource.save!
#     head :ok
#   else
#     render :pay_in
#   end
# end

form do |f|
  f.inputs '用户充值' do
    f.input :money, value: 0.0, label: '充值金额', placeholder: '输入当前要充值的金额，单位为元'
  end
  f.actions
end

end
