ActiveAdmin.register Banner do

  menu priority: 10, label: '广告'
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :image, :link, :sort
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
  column('#', id) { |banner| link_to banner.id, admin_banner_path(banner) }
  column '广告图片', sortable: false do |banner|
    image_tag banner.image.url(:small)
  end
  column('链接地址', sortable: false) { |banner| link_to banner.link, banner.link }
  column :sort
  actions
end


end
