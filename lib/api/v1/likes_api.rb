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
          render_json(@videos, API::V1::Entities::Video, { user: user })
        end # end get liked
      end # end resource
      
      # 用户收藏视频相关
      resource :user, desc: '用户相关接口' do 
        desc "用户点赞"
        params do
          requires :token,       type: String,  desc: "用户认证Token"
          requires :likeable_id, type: Integer, desc: "被点赞对象的ID，比如视频的ID"
          optional :type,        type: Integer, desc: '视频流类型，推荐里面的视频type值为2，直播为1，如果不传该参数，默认为点赞推荐里面的视频'
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
          return render_error(3001, '您已经点赞过了') if user.liked?(likeable)
          
          if user.like!(likeable)
            render_json_no_data
          else
            render_error(3002, 'Oops, 点赞失败了!')
          end
        end # end post like
        
        desc "取消点赞"
        params do
          requires :token, type: String, desc: "用户认证Token"
          requires :likeable_id, type: Integer, desc: "被点赞对象的ID，比如视频的ID"
          optional :type,        type: Integer, desc: '视频流类型，推荐里面的视频type值为2，直播为1，如果不传该参数，默认为点赞推荐里面的视频'
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
          return render_error(3001, '您还未点赞,不能取消点赞') unless user.liked?(likeable)
          
          if user.cancel_like!(likeable)
            render_json_no_data
          else
            render_error(3002, 'Oops, 取消点赞失败了!')
          end
        end # end post like
        
        desc "获取用户赞过的视频"
        params do
          requires :token, type: String, desc: "用户认证Token"
          use :pagination
        end
        get :likes do
          user = authenticate!
          @likes = user.likes.order('id desc')
          @likes = @likes.paginate(page: params[:page], per_page: page_size) if params[:page]
          render_json(@likes, API::V1::Entities::Like, { liked: true, user: user })
        end # end get
        
      end # end resource user
      
    end
  end
end