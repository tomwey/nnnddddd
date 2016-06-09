module API
  module V1
    class LikesAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :videos, desc: '推荐视频相关接口' do
        desc "最受关注的视频"
        params do
          optional :token, type: String, desc: '用户认证Token'
          use :pagination
        end
        get :more_liked do
          @videos = Video.more_liked.hot.recent
          if params[:page]
            @videos = @videos.paginate page: params[:page], per_page: page_size
          end
          user = params[:token].blank? ? nil : User.find_by(private_token: params[:token])
          render_json(@videos, API::V1::Entities::Video, { liked_user: user })
        end # end get liked
      end # end resource
      
      # 用户收藏视频相关
      resource :user, desc: '用户相关接口' do 
        desc "用户收藏"
        params do
          requires :token,       type: String,  desc: "用户认证Token"
          requires :likeable_id, type: Integer, desc: "被收藏对象的ID，比如视频的ID"
          optional :type,        type: Integer, desc: '视频流类型，推荐里面的视频type值为2，直播为1，如果不传该参数，默认为收藏推荐里面的视频'
        end
        post :like do
          user = authenticate!
          
          if params[:type] && params[:type].to_i == 1
            likeable_type = 'LiveVideo'
          else
            likeable_type = 'Video'
          end
          
          klass = likeable_type.classify.constantize
          
          likeable = klass.find_by(id: params[:likeable_id])
          return render_error(3001, '您已经收藏过了') if user.liked?(likeable)
          
          if user.like!(likeable)
            render_json_no_data
          else
            render_error(3002, 'Oops, 收藏失败了!')
          end
        end # end post like
        
        desc "取消收藏"
        params do
          requires :token, type: String, desc: "用户认证Token"
          requires :likeable_id, type: Integer, desc: "被收藏对象的ID，比如视频的ID"
          optional :type,        type: Integer, desc: '视频流类型，推荐里面的视频type值为2，直播为1，如果不传该参数，默认为收藏推荐里面的视频'
        end
        post :cancel_like do
          user = authenticate!
          
          # likeable_type = 'Video'
          if params[:type] && params[:type].to_i == 1
            likeable_type = 'LiveVideo'
          else
            likeable_type = 'Video'
          end
          
          klass = likeable_type.classify.constantize
          
          likeable = klass.find_by(id: params[:likeable_id])
          return render_error(3001, '您还未收藏,不能取消') unless user.liked?(likeable)
          
          if user.cancel_like!(likeable)
            render_json_no_data
          else
            render_error(3002, 'Oops, 取消收藏失败了!')
          end
        end # end post like
        
        desc "获取用户收藏过的视频"
        params do
          requires :token, type: String, desc: "用户认证Token"
          use :pagination
        end
        get :liked_videos do
          user = authenticate!
          @videos = user.liked_videos
          @videos = @videos.paginate(page: params[:page], per_page: page_size) if params[:page]
          render_json(@videos, API::V1::Entities::Video, { liked: true })
        end # end get
        
      end # end resource user
      
    end
  end
end