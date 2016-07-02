ActiveAdmin.register Like do

menu priority: 6

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
filter :likeable_id, as: :select, collection: Video.all.map { |video| [video.title, video.id] }

actions :all, except: [:show, :new, :create, :edit, :update, :destroy]

index do
  selectable_column
  column :id
  column '用户', sortable: false do |like|
    like.user.try(:nickname) || like.user.try(:mobile)
  end
  column '视频', sortable: false do |like|
    raw("
    <video height=\"120\" controls >
      <source src=\"#{like.likeable.try(:video_file_url)}\" type=\"video/mp4\">
      Your browser doesn't support HTML5 video tag.
    </video>")
  end
  column :created_at
end


end
