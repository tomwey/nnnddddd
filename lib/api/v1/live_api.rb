module API
  module V1
    class LiveAPI < Grape::API
      
      resource :live do
        desc "获取直播频道列表"
        get :channels do
          @videos = LiveVideo.fields_for_list.opened.recent
          render_json(@videos, API::V1::Entities::LiveVideo)
        end
        desc "获取最新的直播频道"
        get :latest_channel do
          @video = LiveVideo.fields_for_list.opened.recent.first
          render_json(@video, API::V1::Entities::LiveVideo)
        end
      end # end resource
      
      resource :videos do
        desc "获取热门直播视频列表"
        get :from_live do
          
        end # end get
      end # video resource
      
    end
  end
end