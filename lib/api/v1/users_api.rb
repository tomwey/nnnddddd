module API
  module V1
    class UsersAPI < Grape::API
      # 用户快捷登录
      resource :account do
        desc "用户登录"
        params do
          requires :mobile, type: String, desc: "用户手机号，必须"
          requires :code,   type: String, desc: "短信验证码，必须"
        end
        post :login do
          # 手机号检测
          unless check_mobile(params[:mobile])
            return render_error(1001, "不正确的手机号")
          end
          
          # TODO: 验证码检测
          
          # 快捷登录
          u = User.find_by(mobile: params[:mobile])
          if u.blank?
            u = User.create!(mobile: params[:mobile])
          end
          render_json(u, API::V1::Entities::User)
          
        end # end post login
      end # end account resource
      
      # 三方快捷登录
      resource :auth do
        desc "三方认证快捷登录"
        params do
          requires :uid,        type: String, desc: "第三方登录用户唯一ID"
          requires :provider,   type: String, desc: "第三方登录平台名称，例如：Wechat, QQ, Weibo等"
          optional :nickname,   type: String, desc: "第三方登录用户的昵称"
          optional :avatar_url, type: String, desc: "第三方登录用户的头像URL地址"
        end
        post :login do
          provider = params[:provider].downcase
          auth = Authorization.where('lower(provider) = ? and uid = ?', provider, params[:uid]).first
          if auth.present?
            return render_json(auth.user, API::V1::Entities::User, opts: auth)
          end
          
          user = User.new
          user.nickname = params[:nickname] if params[:nickname].present?
          user.remote_avatar_url = params[:avatar_url] if params[:avatar_url].present?
          user.authorizations << Authorization.new(provider: provider, uid: params[:uid])
          
          if user.save
            # 添加认证
            # Authorization.create!(provider: params[:provider], uid: params[:uid], user_id: user.id)
            render_json(user, API::V1::Entities::User, opts: auth)
          else
            render_error(1006, user.errors.full_messages.join(','))
          end
        end # end end login
        
        desc "绑定手机号"
        params do
          # requires :token,  type: String, desc: "用户认证Token"
          requires :uid,        type: String, desc: "第三方登录用户唯一ID"
          requires :provider,   type: String, desc: "第三方登录平台名称，例如：Wechat, QQ, Weibo等"
          requires :mobile, type: String, desc: "用户手机"
          requires :code,   type: String, desc: "验证码"
        end
        post :bind do
          # user = authenticate!
          
          # 手机号检测
          unless check_mobile(params[:mobile])
            return render_error(1001, "不正确的手机号")
          end
          
          provider = params[:provider].downcase
          
          auth = Authorization.where('lower(provider) = ? and uid = ?', provider, params[:uid]).first
          if auth.blank?
            return render_error(1003, "不正确的uid或provider")
          end
          
          auth_user = auth.user
          
          if auth_user.blank?
            return render_error(1004, "非法用户")
          end
          
          if auth_user.mobile.present?
            return render_error(1005, "您已经绑定过手机")
          end
          
          current_user = User.find_by(mobile: params[:mobile])
          if current_user.present?
            # 该手机号已经存在或者被绑定过
            # 更新用户的个人资料
            if current_user.nickname.blank?
              current_user.nickname = auth_user.nickname
            end
            if current_user.avatar.blank?
              current_user.avatar   = auth_user.avatar
            end
            current_user.save!
            
            # 绑定认证
            auth.user_id = current_user.id
            auth.save!
            
            # 软删除之前的三方认证账号
            auth_user.update!({ visible: false })
            
            # 返回结果
            render_json(current_user, API::V1::Entities::User)
          else
            # 该手机号不存在或者未被绑定过，直接将手机号绑定到登录账号
            if auth_user.update_attribute(:mobile, params[:mobile])
              render_json(auth_user, API::V1::Entities::User)
            else
              render_error(1006, user.errors.full_messages.join(','))
            end
          end
          
        end # end post bind
        
      end # end resource auth
      
      resource :user do
        
        desc "获取个人资料"
        params do
          requires :token, type: String, desc: "用户认证Token"
        end
        get :me do
          # user = authenticate!
          user = User.find_by(private_token: params[:token])
          render_json(user, API::V1::Entities::User)
        end # end get me
        
        desc "修改头像"
        params do
          requires :token,  type: String, desc: "用户认证Token, 必须"
          requires :avatar, type: Rack::Multipart::UploadedFile, desc: "用户头像"
        end
        post :update_avatar do
          user = authenticate!
          
          if params[:avatar]
            user.avatar = params[:avatar]
          end
          
          if user.save
            render_json(user, API::V1::Entities::User)
          else
            render_error(3001, user.errors.full_messages.join(","))
          end
        end # end update_avatar
        
        desc "修改昵称"
        params do
          requires :token,    type: String, desc: "用户认证Token, 必须"
          requires :nickname, type: String, desc: "用户昵称"
        end
        post :update_nickname do
          user = authenticate!
          
          if params[:nickname]
            user.nickname = params[:nickname]
          end
          
          if user.save
            render_json(user, API::V1::Entities::User)
          else
            render_error(3002, user.errors.full_messages.join(","))
          end
        end # end update nickname
        
      end # end user resource
      
    end 
  end
end