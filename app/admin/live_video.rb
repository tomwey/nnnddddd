ActiveAdmin.register LiveVideo do

menu priority: 4, label: '直播'

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :body, :lived_at, :live_address, { images: [] }, :stream_id
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
  column :id
  column(:title, sortable: false) 
  column :body, sortable: false
  column :lived_at
  column :live_address
  # column '活动图片', sortable: false do |live_video|
  #   ul do
  #     live_video.images.each do |image|
  #       li do
  #         image_tag(image.url(:small), size: '120x74')
  #       end
  #     end
  #   end
  # end
  column '直播流ID', sortable: false do |lv|
    lv.stream_id
  end
  column '人数统计' do |lv|
    # lv.online_users_count
    raw("围观人数：#{lv.view_count}<br>在线人数：#{lv.online_users_count}")
  end
  column '直播相关', columns: 3, sortable: false do |live_video|
    raw("RTMP推流地址：#{live_video.rtmp_push_url}<br>
         RTMP直播地址：#{live_video.rtmp_url}<br>
         HLS直播地址： #{live_video.hls_url}<br>
         视频录制地址： #{live_video.vod_url}")
  end
  
  column '直播状态', sortable: false do |live_video|
    live_video.try(:state_info)
  end
  
  actions defaults: false do |channel|
    if channel.can_live?
      item '开始直播', open_admin_live_video_path(channel), method: :put
    elsif channel.can_close?
      item '关闭直播', close_admin_live_video_path(channel), method: :put
    end
    item " 编辑", edit_admin_live_video_path(channel)
  end
  # actions defaults: false do |product|
  #   item "编辑", edit_admin_product_path(product)
  #   if product.on_sale
  #     item "下架", unsale_admin_product_path(product), method: :put
  #   else
  #     item "上架", sale_admin_product_path(product), method: :put
  #   end
  # end
  
end

# 批量开启
batch_action :open do |ids|
  batch_action_collection.find(ids).each do |channel|
    channel.open!
  end
  redirect_to collection_path, alert: '开启成功'
end

# 批量关闭
batch_action :close do |ids|
  batch_action_collection.find(ids).each do |channel|
    channel.close!
  end
  redirect_to collection_path, alert: '关闭成功'
end

member_action :open, method: :put do
  resource.open!
  redirect_to collection_path, notice: "已开启"
end

member_action :close, method: :put do
  resource.close!
  redirect_to collection_path, notice: "已关闭"
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :title
    f.input :body
    f.input :lived_at, as: :string, placeholder: '格式为：2016-01-01 14:30:00'
    f.input :live_address
    f.input :images, as: :file, input_html: { multiple: true }
  end
  
  actions
end

end
