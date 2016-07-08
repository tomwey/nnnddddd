ActiveAdmin.register Page do

menu priority: 8, label: "文档"

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :slug, :body

filter :title
filter :slug
filter :created_at

index do
  selectable_column
  column('#',:id) { |page| link_to page.id, admin_page_path(page) }
  column(:title, sortable: false) { |page| link_to page.title, admin_page_path(page) }
  column('链接地址', sortable: false) { |page| link_to "#{Setting.upload_url}/p/#{page.slug}", "#{Setting.upload_url}/p/#{page.slug}"  }
  
  actions
end

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

# form do |f|
#   f.inputs do
#     f.input :title
#     f.input :slug
#     f.input :body, as: :html_editor
#   end
#   
#   # f.buttons
# end
form partial: 'form'

end
