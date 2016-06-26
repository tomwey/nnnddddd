ActiveAdmin.register PayHistory do

menu priority: 6

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

actions :index

index do
  selectable_column
  column :id
  column '用户', sortable: false do |ph|
    ph.user.try(:nickname) || ph.user.try(:mobile)
  end
  column :pay_name, sortable: false
  column :money
  column('时间', :created_at)
end


end
