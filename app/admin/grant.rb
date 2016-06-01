ActiveAdmin.register Grant do

menu priority: 6, label: '打赏'

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
index do
  selectable_column
  column '#', :id
  column '打赏人', sortable: false do |grant|
    grant.granting_user.try(:nickname) || grant.granting_user.try(:hack_name)
  end
  column :money
  column '被打赏人', sortable: false do |grant|
    if grant.granted_user.blank?
      '系统'
    else
      grant.granted_user.try(:nickname) || grant.granted_user.try(:hack_name)
    end
  end
  column('打赏时间', :created_at)
  actions
end


end
