module API
  module V1
    class ViewHistoriesAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :view_histories, desc: '观看历史' do
        desc '获取用户所有最近的观看历史'
        params do
          requires :token, type: String, desc: 'Token, 必须'
          use :pagination
        end
        get do
          user = authenticate!
          @videos = user.viewed_videos.order('view_histories.id desc')
          @videos = @videos.paginate(page: params[:page], per_page: page_size) if params[:page]
          render_json(@videos, API::V1::Entities::Video)
        end # end get
        
        desc '上传一条观看历史'
        params do
          requires :token, type: String, desc: 'Token, 必须'
          requires :viewable_id, type: Integer, desc: '视频ID'
          requires :progress, type: Integer, desc: '播放进度，以秒为单位'
          optional :type, type: Integer, desc: '类别，如果为1表示是直播视频，为2是点播视频，默认为点播'
        end
        post :create do
          user = authenticate!
          
          if params[:type] && params[:type].to_i == 1
            viewable_type = 'LiveVideo'
          else
            viewable_type = 'Video'
          end
          
          ViewHistory.create!(user_id: user.id, 
                              viewable_id: params[:viewable_id],
                              viewable_type: viewable_type,
                              playback_progress: params[:progress])
                  
          render_json_no_data
          
        end # end post
        
        desc '删除一条观看历史'
        params do
          requires :token, type: String, desc: 'Token, 必须'
          requires :viewable_id, type: Integer, desc: '视频ID'
          optional :type, type: Integer, desc: '类别，如果为1表示是直播视频，为2是点播视频，默认为点播'
        end
        post :delete do
          user = authenticate!
          
          if params[:type] && params[:type].to_i == 1
            viewable_type = 'LiveVideo'
          else
            viewable_type = 'Video'
          end
          
          klass = viewable_type.classify.constantize
          klass.where(user_id: user.id, viewable_id: params[:viewable_id]).delete_all
          
          render_json_no_data
        end # end post
      end # end resource
      
    end
  end
end