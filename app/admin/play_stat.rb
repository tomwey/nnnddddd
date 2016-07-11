ActiveAdmin.register PlayStat do

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

actions :all, except: [:show, :new, :create, :edit, :update, :destroy]

index do
  # selectable_column
  column 'ID', :id
  column :stream_id, sortable: false
  column '视频流类型', sortable: false do |ps|
    ps.stream_type == 1 ? '直播' : '点播'
  end
  column :udid, sortable: false
  column :device_model, sortable: false
  column :os_version, sortable: false
  column :app_version, sortable: false
  column :screen_size, sortable: false
  # column :lang_code, sortable: false
  # column :country_code, sortable: false
  column '国家语言', sortable: false do |ps|
    "#{ps.lang_code}_#{ps.country_code}"
  end
  column :created_at
  
end


end
