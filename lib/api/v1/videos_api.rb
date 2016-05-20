module API
  module V1
    class VideosAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :videos do
        desc "获取推荐视频列表"
        params do
          optional :cid, type: Integer, desc: "类别ID, 如果不传该参数，默认返回所有的视频"
          use :pagination
        end
        get do
          @videos = Video.no_from_live.sorted.hot.recent
          
          if params[:cid]
            @videos = @videos.where(category_id: params[:cid])
          end
          
          @videos = @videos.paginate(page: params[:page], per_page: page_size) if params[:page]
          
          render_json(@videos, API::V1::Entities::Video)
        end # end get videos
        
        desc "上传视频"
        params do 
          requires :token,       type: String,  desc: "用户认证Token"
          requires :category_id, type: Integer, desc: "类别ID"
          requires :title,       type: String,  desc: "视频简介"
          requires :video,       type: Rack::Multipart::UploadedFile, desc: "视频二进制文件, 视频格式为：mp4或者mov"
        end
        post do
          user = authenticate!
          
          category = Category.find_by(id: params[:category_id])
          if category.blank?
            return render_error(4004, '没有该类别')
          end
          
          @video = Video.new(user_id: user.id, 
                             title: params[:title], 
                             file: params[:video], 
                             category_id: params[:category_id])
          if @video.save
            render_json(@video, API::V1::Entities::Video)
          else
            render_error(6001, @video.errors.full_messages.join(','))
          end
        end # end post
        
      end # end resource
    end
  end
end