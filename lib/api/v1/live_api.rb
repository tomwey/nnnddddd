module API
  module V1
    class LiveAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :live do
        desc "获取直播列表"
        get :channels do
          @videos = LiveVideo.living.recent
          render_json(@videos, API::V1::Entities::LiveVideo)
        end
        
        desc "获取最新的直播"
        get :latest_channel do
          @video = LiveVideo.living.recent.first
          render_json(@video, API::V1::Entities::LiveVideo)
        end
        
        desc "获取热门直播"
        params do
          use :pagination
        end
        get :hot_videos do
          @videos = Video.from_live.sorted.hot.recent
          @videos = @videos.paginate(page: params[:page], per_page: page_size) if params[:page]
          render_json(@videos, API::V1::Entities::SimpleVideo)
        end # end get
      end # end resource
      
      # 统计信息
      resource :stat do
        desc "播放统计"
        params do
          requires :sid,  type: String,  desc: "视频流ID, 值为服务器返回的stream_id字段的值"
          # requires :st,   type: Integer, desc: "视频流类型，1表示的直播，2表示的点播"
          requires :udid, type: String,  desc: "用户UDID"
          requires :m,    type: String,  desc: "用户设备，例如：iPhone_6s或M571C"
          requires :osv,  type: String,  desc: "用户设备系统版本号"
          requires :bv,   type: String,  desc: "用户app当前版本号"
          requires :sr,   type: String,  desc: "设备屏幕分辨率，例如：1080x1920"
          requires :lc,   type: String,  desc: "语言码，例如：zh_CN"
          requires :cc,   type: String,  desc: "国家码，例如：中国:CN, 美国:US"
        end
        get :play do
          
          PlayStat.where(
            stream_id: params[:sid],
            stream_type: 2,
            udid: params[:udid],
            device_model: params[:m],
            os_version: params[:osv],
            app_version: params[:bv],
            screen_size: params[:sr],
            lang_code: params[:lc],
            country_code: params[:cc]
          ).first_or_create!
          
        end # end get play
        
        desc "直播统计"
        params do
          requires :sid,  type: String,  desc: "视频流ID, 值为服务器返回的stream_id字段的值"
          # requires :st,   type: Integer, desc: "视频流类型，1表示的直播，2表示的点播"
          requires :udid, type: String,  desc: "用户UDID"
          requires :m,    type: String,  desc: "用户设备，例如：iPhone_6s或M571C"
          requires :osv,  type: String,  desc: "用户设备系统版本号"
          requires :bv,   type: String,  desc: "用户app当前版本号"
          requires :sr,   type: String,  desc: "设备屏幕分辨率，例如：1080x1920"
          requires :lc,   type: String,  desc: "语言码，例如：zh_CN"
          requires :cc,   type: String,  desc: "国家码，例如：中国:CN, 美国:US"
        end
        get :live do
          
          lv = LiveVideo.find_by(stream_id: params[:sid])
          lv.increamt_online_user(1) unless lv.blank?
          
          PlayStat.where(
            stream_id: params[:sid],
            stream_type: 1,
            udid: params[:udid],
            device_model: params[:m],
            os_version: params[:osv],
            app_version: params[:bv],
            screen_size: params[:sr],
            lang_code: params[:lc],
            country_code: params[:cc]
          ).first_or_create!
          
        end # end get live
        
        desc "取消直播统计"
        params do
          requires :sid,  type: String,  desc: "视频流ID, 值为服务器返回的stream_id字段的值"
          # requires :st,   type: Integer, desc: "视频流类型，1表示的直播，2表示的点播"
          requires :udid, type: String,  desc: "用户UDID"
          requires :m,    type: String,  desc: "用户设备，例如：iPhone_6s或M571C"
          requires :osv,  type: String,  desc: "用户设备系统版本号"
          requires :bv,   type: String,  desc: "用户app当前版本号"
          requires :sr,   type: String,  desc: "设备屏幕分辨率，例如：1080x1920"
          requires :lc,   type: String,  desc: "语言码，例如：zh_CN"
          requires :cc,   type: String,  desc: "国家码，例如：中国:CN, 美国:US"
        end
        get :cancel_live do
          
          lv = LiveVideo.find_by(stream_id: params[:sid])
          lv.increamt_online_user(-1) unless lv.blank?
          
          PlayStat.where(
            stream_id: params[:sid],
            stream_type: 1,
            udid: params[:udid],
            device_model: params[:m],
            os_version: params[:osv],
            app_version: params[:bv],
            screen_size: params[:sr],
            lang_code: params[:lc],
            country_code: params[:cc]
          ).first_or_create!
          
        end # end get live
        
      end # end stat resource
      
    end
  end
end