ActiveAdmin.register Category do

menu priority: 3, label: '类别'
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :icon, :sort, :user_upload
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
# controller do
#   def index
#     @categories = Category.no_delete.order('id desc')
#   end
# end

index do
  selectable_column
  column('#', id) { |cata| link_to cata.id, admin_category_path(cata) }
  column :name, sortable: false
  column '类别图', sortable: false do |cata|
    if cata.icon.blank?
      ''
    else
      image_tag cata.icon.url(:small)
    end
  end
  column '是否属于用户上传', sortable: false do |cata|
    cata.user_upload ? '是' : '否'
  end
  column :sort
  # actions
  actions defaults: false do |cata|
    if cata.opened
      item '关闭', close_admin_category_path(cata), method: :put
    else
      item '打开', open_admin_category_path(cata), method: :put
    end
    item " 编辑", edit_admin_category_path(cata)
    item " 删除", delete_admin_category_path(cata), method: :put, data: { confirm: '你确定吗？' }
    # item " 删除", delete_admin_category_path(cata), method: :delete, data: { confirm: '你确定吗？' }
  end
end

# 批量打开
batch_action :open do |ids|
  batch_action_collection.find(ids).each do |cata|
    cata.open!
  end
  redirect_to collection_path, alert: '打开成功'
end

# 批量关闭
batch_action :close do |ids|
  batch_action_collection.find(ids).each do |cata|
    cata.close!
  end
  redirect_to collection_path, alert: '关闭成功'
end

# 批量删除
batch_action :delete do |ids|
  batch_action_collection.find(ids).each do |cata|
    cata.delete!
  end
  redirect_to collection_path, alert: '删除成功'
end

member_action :open, method: :put do
  resource.open!
  redirect_to collection_path, notice: "已打开"
end

member_action :close, method: :put do
  resource.close!
  redirect_to collection_path, notice: "已关闭"
end

member_action :delete, method: :put do
  resource.delete!
  redirect_to collection_path, notice: "已删除"
end

form html: { multipart: true } do |f|
  f.semantic_errors

  f.inputs do
    f.input :name
    f.input :icon, as: :file, label: '类别图', hint: 'icon，格式为：jpg,jpeg,png,gif'
    f.input :user_upload, hint: '该类别是否用于用户上传'
    f.input :sort, hint: '显示顺序，值越大，显示越靠前'
  end

  actions
end


end
