module API
  module V1
    class BilibilisAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :bilibilis, desc: "弹幕接口" do
        desc "获取某个视频流的最新的一部分弹幕消息"
        params do
          requires :sid,  type: String, desc: "视频ID"
          optional :size, type: Integer, desc: "获取记录的条数，默认为30条"
        end
        get :latest do
          total = params[:size] || 30
          @bibis = Bilibili.where(stream_id: params[:sid]).order('id desc').limit(total.to_i)
          render_json(@bibis, API::V1::Entities::Bilibili)
        end # end get
        
        desc "分页获取某个视频流的弹幕消息"
        params do
          requires :sid,  type: String, desc: "视频ID"
          use :pagination
        end
        get do
          @bibis = Bilibili.where(stream_id: params[:sid]).order('id desc')
          @bibis = @bibis.paginate(page: params[:page], per_page: page_size) if params[:page]
          render_json(@bibis, API::V1::Entities::Bilibili)
        end # end get
        
        desc "保存弹幕消息"
        params do
          requires :content,   type: String, desc: "弹幕内容，255个字符长度"
          requires :stream_id, type: String, desc: "视频流ID"
          optional :token,     type: String, desc: "用户认证Token"
          optional :location,  type: String, desc: "弹幕作者的位置信息，保留参数，留着以后用"
        end
        post do
          @bili = Bilibili.new(content: params[:content], stream_id: params[:stream_id], location: params[:location])
          
          if params[:token].present?
            u = User.find_by(private_token: params[:token])
            @bili.author_id = u.id if u.present?
          end
          
          if @bili.save
            video = Video.find_by(stream_id: params[:stream_id])
            if video.present?
              # 添加统计数据
              video.msg_count += 1
              video.save
            else
              lv = LiveVideo.find_by(stream_id: params[:stream_id])
              if lv.present?
                # 添加统计数据
                lv.msg_count += 1
                lv.save
              end
            end
            render_json(@bili, API::V1::Entities::Bilibili)
          else
            render_error(5001, @bili.errors.full_messages.join(','))
          end
          
        end # end post
        
      end # end resource
      
    end
  end
end