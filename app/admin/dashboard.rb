ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: "最新数据统计" do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    
    columns do
      
      column do
        panel "最新用户" do
          table_for User.order('id desc').limit(20) do
            column :id
            column('头像') { |user| image_tag(user.avatar_url(:large), size: '60x60') }
            column('账户') { |user| user.nickname || user.hack_mobile }
          end
        end
      end # end user
      
      column do
        panel "最新点赞" do
          table_for Like.order('id desc').limit(20) do
            column :id
            column '用户', sortable: false do |like|
              like.user.try(:nickname) || like.user.try(:hack_mobile)
            end
            column '视频', sortable: false do |like|
              like.likeable.try(:title)
            end
          end
        end
      end
      
    end
    
    columns do
      
      column do
        panel "最新播放统计" do
          table_for PlayStat.order('id desc').limit(20) do
            column :id
            column '视频流' do |ps|
              "[#{ps.stream_type == 1 ? "直播" : "点播"}] #{ps.stream.try(:title)}"
            end
            column :udid, sortable: false
            column :device_model, sortable: false
            column :os_version, sortable: false
            column :app_version, sortable: false
            column :screen_size, sortable: false
            column '国家语言', sortable: false do |ps|
              "#{ps.lang_code}_#{ps.country_code}"
            end
          end
        end
      end
      
    end
    
  end # content
end
