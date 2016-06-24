require 'qiniu'
module API
  module V1
    class VideosAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :videos, desc: '视频推荐接口' do
        desc "获取推荐视频列表"
        params do
          optional :cid,   type: Integer, desc: "类别ID, 如果不传该参数，默认返回所有的视频"
          optional :token, type: String,  desc: "如果用户登陆，那么需要传人认证Token"
          use :pagination
        end
        get do
          @videos = Video.sorted.hot.recent
          
          if params[:cid]
            @videos = @videos.where(category_id: params[:cid])
          end
          
          @videos = @videos.paginate(page: params[:page], per_page: page_size) if params[:page]
          
          user = params[:token].blank? ? nil : User.find_by(private_token: params[:token])

          render_json(@videos, API::V1::Entities::Video, { user: user })
        end # end get videos
        
        desc "获取用户上传的视频"
        params do 
          requires :token, type: String,  desc: "用户认证Token"
          use :pagination
        end
        get :uploaded do
          user = authenticate!
          
          category = Category.find_by(name: '拍客')
          @videos = Video.where(category_id: category.id, user_id: user.id).order('id desc')
          
          # 分页
          @videos = @videos.paginate(page: params[:page], per_page: page_size) if params[:page]
          
          render_json(@videos, API::V1::Entities::Video, { user: user })
        end # end get
        
        desc "获取上传视频的Token信息"
        params do
          requires :token, type: String,  desc: "用户认证Token"
        end
        get :upload_info do
          authenticate!
          
          bucket = 'zgnytv'
          filename = "#{SecureRandom.uuid}.mp4"
          key = "uploads/video/" + filename
          
          #构建上传策略
          put_policy = Qiniu::Auth::PutPolicy.new(
              bucket,      # 存储空间
              key,     # 最终资源名，可省略，即缺省为“创建”语义，设置为nil为普通上传 
              3600    #token过期时间，默认为3600s
          )

          #生成上传 Token
          uptoken = Qiniu::Auth.generate_uptoken(put_policy)
          
          { token: uptoken, key: key, filename: filename }
          
        end # end token
        
        desc "上传视频"
        params do 
          requires :token,       type: String,  desc: "用户认证Token"
          # optional :category_id, type: Integer, desc: "类别ID"
          requires :title,       type: String,  desc: "视频标题"
          optional :body,        type: String,  desc: "视频简介"
          # requires :video,       type: Rack::Multipart::UploadedFile, desc: "视频二进制文件, 视频格式为：mp4,mov,3gp,avi,mpeg"
          requires :cover_image, type: Rack::Multipart::UploadedFile, desc: "图片二进制文件, 视频格式为：jpg,jpeg,gif,png"
          requires :filename,    type: String,  desc: "视频文件名" 
        end
        post do
          user = authenticate!
          
          # category_id = params[:category_id].blank? ? 3 : params[:category_id].to_i
          category = Category.find_by(name: '拍客')
          if category.blank?
            return render_error(4004, '没有该类别')
          end
          
          @video = Video.new(user_id: user.id, 
                             title: params[:title], 
                             file: params[:filename], 
                             category_id: category.id,
                             cover_image: params[:cover_image],
                             body: params[:body])
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