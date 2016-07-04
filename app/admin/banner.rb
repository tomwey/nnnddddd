ActiveAdmin.register Banner do

  menu priority: 10, label: '广告'
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :image, :link, :sort, :category_id
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
  column '所属类别', sortable: false do |banner|
    banner.category.try(:name) || ''
  end
  column :sort
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors

  f.inputs  do
    f.input :image, as: :file, label: '广告图片', hint: '格式为：jpg, jpeg, png, gif；尺寸为：1080x580'
    f.input :link, label: '广告链接', hint: '字段值可以是一个网址（例如：http://www.baidu.com），也可以是一个视频的流 ID（例如：400d3e0d4a734e9fafb02f3f7f58631e）'
    f.input :category_id, as: :select, label: '所属类别', collection: Category.no_delete.opened.map { |category| [category.name, category.id] }, prompt: '-- 请选择类别 --', hint: '如果没有选择，那么广告会出现在搜索页面，否则会在推荐页面的每个类别下面'
    f.input :sort, hint: '显示顺序，值越大，显示越靠前'
  end

  actions
end

end
