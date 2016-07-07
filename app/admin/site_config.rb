ActiveAdmin.register SiteConfig do

menu priority: 1, label: '站点配置'

# menu false if current_admin.super_admin?
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :key, :value, :description, :file
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

form html: { multipart: true } do |f|
  f.semantic_errors

  f.inputs  do
    f.input :file, as: :file#, hint: '格式为：jpg, jpeg, png, gif；尺寸为：1080x580'
    f.input :key
    f.input :value
    f.input :description
  end

  actions
end

end
