ActiveAdmin.register ViewHistory do

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
  column '用户', sortable: false do |vh|
    if vh.user.present?
      vh.user.try(:nickname) || vh.user.try(:hack_mobile)
    else
      ''
    end
  end
  column '类型', sortable: false do |vh|
    vh.viewable_type == 'Video' ? "点播" : "直播"
  end
  column '视频流标题', sortable: false do |vh|
    vh.viewable.try(:title)
  end
  column '播放进度 ( 秒 )', :playback_progress
  column '时间', :created_at
  
end


end
