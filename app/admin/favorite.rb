ActiveAdmin.register Favorite do

menu priority: 6

index do
  selectable_column
  column :id
  column '用户', sortable: false do |favorite|
    favorite.user.try(:nickname) || favorite.user.try(:mobile)
  end
  column '视频', sortable: false do |favorite|
    raw("
    <video height=\"120\" controls >
      <source src=\"#{favorite.favoriteable.video_file_url}\" type=\"video/mp4\">
      Your browser doesn't support HTML5 video tag.
    </video>")
  end
  column :created_at
end


end
