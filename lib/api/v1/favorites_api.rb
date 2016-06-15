module API
  module V1
    class FavoritesAPI < Grape::API
      
      helpers API::SharedParams
            
      # 用户收藏视频相关
      resource :user, desc: '用户相关接口' do 
        desc "用户收藏"
        params do
          requires :token,       type: String,  desc: "用户认证Token"
          requires :favorite_id, type: Integer, desc: "被收藏对象的ID，比如视频的ID"
          optional :type,        type: Integer, desc: '视频流类型，推荐里面的视频type值为2，直播为1，如果不传该参数，默认为点赞推荐里面的视频'
        end
        post :favorite do
          user = authenticate!
          
          if params[:type] && params[:type].to_i == 1
            favorite_type = 'LiveVideo'
          else
            favorite_type = 'Video'
          end
          
          klass = favorite_type.classify.constantize
          
          favoriteable = klass.find_by(id: params[:favorite_id])
          return render_error(3001, '您已经收藏过了') if user.favorited?(favoriteable)
          
          if user.favorite!(favoriteable)
            render_json_no_data
          else
            render_error(3002, 'Oops, 收藏失败了!')
          end
        end # end post like
        
        desc "取消收藏"
        params do
          requires :token,       type: String, desc: "用户认证Token"
          requires :favorite_id, type: Integer, desc: "被收藏对象的ID，比如视频的ID"
          optional :type,        type: Integer, desc: '视频流类型，推荐里面的视频type值为2，直播为1，如果不传该参数，默认为取消收藏推荐里面的视频'
        end
        post :cancel_favorite do
          user = authenticate!
          
          # likeable_type = 'Video'
          if params[:type] && params[:type].to_i == 1
            favorite_type = 'LiveVideo'
          else
            favorite_type = 'Video'
          end
          
          klass = favorite_type.classify.constantize
          
          favoriteable = klass.find_by(id: params[:favorite_id])
          return render_error(3001, '您还未收藏,不能取消') unless user.favorited?(favoriteable)
          
          if user.cancel_favorite!(favoriteable)
            render_json_no_data
          else
            render_error(3002, 'Oops, 取消收藏失败了!')
          end
        end # end post like
        
        desc "获取用户收藏的视频"
        params do
          requires :token, type: String, desc: "用户认证Token"
          use :pagination
        end
        get :favorites do
          user = authenticate!
          @favorites = user.favorites.includes(:favoriteable).order('id desc')
          @favorites = @favorites.paginate(page: params[:page], per_page: page_size) if params[:page]
          @favoriteables = @favorites.map { |f| f.favoriteable }
          render_json(@favoriteables, API::V1::Entities::Stream, { user: user, favorited: true })
        end # end get
        
      end # end resource user
      
    end
  end
end