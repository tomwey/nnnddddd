ActiveAdmin.register Video do

menu priority: 5, label: '视频'

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :file, :cover_image, :body, :category_id#, :stream_id
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
    raw("观看人数：#{video.view_count}<br>弹幕数：#{video.msg_count}<br>收藏数：#{video.likes_count}")
  end
  column '所属类别', sortable: false do |video|
    video.category.try(:name)
  end
  column '所属用户', sortable: false do |video|
    video.user_id == -1 ? '系统' : video.user.try(:nickname)
  end
  column :sort
  actions
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
