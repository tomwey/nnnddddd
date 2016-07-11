ActiveAdmin.register Search do

menu priority: 6, label: '搜索统计'

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

actions :all, except: [:show, :new, :create, :edit, :update]

index do
  # selectable_column
  column '#', :id
  column :keyword, sortable: false
  column :search_count
  actions defaults: false do |search|
    item "删除", admin_search_path(search), method: :delete, data: { confirm: '你确定吗？' }
  end
end


end
