ActiveAdmin.register Bilibili do

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

actions :all, except: [:show, :edit, :update]

filter :content
filter :stream_id
filter :created_at

index do
  selectable_column
  column '#' do |bili|
    bili.id
  end
  column :content, sortable: false
  column '作者', sortable: false do |bili|
    bili.author_name
  end
  column :stream_id, sortable: false
  column :created_at
  actions
end

end
