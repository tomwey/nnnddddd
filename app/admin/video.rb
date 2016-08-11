ActiveAdmin.register Video do

menu priority: 5, label: '视频'

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :file, :cover_image, :body, :category_id, :likes_count, :view_count, :sort#, :stream_id
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
  column('#', id) { |video| link_to video.id, admin_video_path(video) }
  column '视频封面图', sortable: false do |video|
    if video.cover_image.blank?
      ''
    else
      image_tag video.cover_image.url(:small)
    end
  end
  column :title, sortable: false
  column '视频文件', sortable: false do |video|
    raw("
    <video height=\"120\" controls >
      <source src=\"#{video.file_url}\" type=\"video/mp4\">
      Your browser doesn't support HTML5 video tag.
    </video>")
  end
  column :stream_id, sortable: false
  column '人数统计', sortable: false do |video|
    raw("观看人数：#{video.view_count}<br>弹幕数：#{video.msg_count}<br>点赞数：#{video.likes_count}")
  end
  column '所属类别', sortable: false do |video|
    video.category.try(:name)
  end
  column '所属用户', sortable: false do |video|
    video.user_id == -1 ? '系统' : video.user.try(:nickname)
  end
  column '审核状态', sortable: false do |video|
    if video.approved
      '已审核'
    else
      '未审核'
    end
  end
  column :sort
  # actions
  actions defaults: false do |video|
    if video.approved
      item '取消审核', cancel_approve_admin_video_path(video), method: :put
    else
      item '确认审核', approve_admin_video_path(video), method: :put
    end
    item " 编辑", edit_admin_video_path(video)
    item " 删除", admin_video_path(video), method: :delete, data: { confirm: '你确定吗？' }
  end
end

# 批量审核
batch_action :approve do |ids|
  batch_action_collection.find(ids).each do |video|
    video.approve!
  end
  redirect_to collection_path, alert: '审核通过'
end

# 批量审核不通过
batch_action :cancel_approve do |ids|
  batch_action_collection.find(ids).each do |video|
    video.cancel_approve!
  end
  redirect_to collection_path, alert: '取消审核'
end

member_action :approve, method: :put do
  resource.approve!
  redirect_to collection_path, notice: "已审核"
end

member_action :cancel_approve, method: :put do
  resource.cancel_approve!
  redirect_to collection_path, notice: "已取消"
end

show do |video|
  h3 video.title
  div raw(video.body)
  br
  div do
    raw("
    <video width=\"640\" controls >
      <source src=\"#{video.file_url}\" type=\"video/mp4\">
      Your browser doesn't support HTML5 video tag.
    </video>")
  end
end

# form html: { multipart: true } do |f|
#   f.semantic_errors
#   
#   f.inputs do
#     f.input :category_id, as: :select, collection: Category.all.map { |category| [category.name, category.id] }, prompt: '-- 请选择类别 --'
#     f.input :title
#     f.input :cover_image, as: :file, hint: '上传封面图，格式为：jpg,jpeg,png,gif'
#     f.input :file, as: :file, hint: '上传视频文件，格式为：mp4 mov avi 3gp mpeg'
#     f.input :body
#     f.input :sort, hint: '视频显示顺序，值越大，显示越靠前'
#   end 
#   
#   actions
# end
form partial: 'form'

end
