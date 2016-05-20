module API
  module V1
    module Entities
      class Base < Grape::Entity
        format_with(:null) { |v| v.blank? ? "" : v }
        format_with(:chinese_date) { |v| v.blank? ? "" : v.strftime('%Y-%m-%d') }
        format_with(:chinese_datetime) { |v| v.blank? ? "" : v.strftime('%Y-%m-%d %H:%M:%S') }
        expose :id
        # expose :created_at, format_with: :chinese_datetime
      end # end Base
      
      # 用户基本信息
      class UserProfile < Base
        expose :mobile, format_with: :null
        expose :nickname do |model, opts|
          model.nickname || model.mobile
        end
        expose :avatar do |model, opts|
          model.avatar.blank? ? "" : model.avatar_url(:large)
        end
      end
      
      # 用户详情
      class User < UserProfile
        expose :private_token, as: :token, format_with: :null
      end
      
      # 类别详情
      class Category < Base
        expose :name, format_with: :null
        expose :icon do |model, opts|
          model.icon.blank? ? "" : model.icon.url(:icon)
         end
      end
      
      # 点播视频
      class SimpleVideo < Base
        expose :title, format_with: :null
        expose :video_file do |model, opts|
          model.file.blank? ? "" : model.file.url#model.file.url(:mp4)
        end
        expose :cover_image do |model, opts|
          model.file.blank? ? "" : model.file.url(:cover_image)
        end
        expose :view_count, :likes_count, :type
        expose :created_on do |model, opts|
          model.created_at.blank? ? "" : model.created_at.strftime('%Y-%m-%d')
        end
      end
      
      class Video < SimpleVideo
        expose :category, using: API::V1::Entities::Category
        expose :user,     using: API::V1::Entities::UserProfile, if: Proc.new { |video| video.user_id > 0 }
      end
      
      class LiveHotVideo < Base
        expose :title,       format_with: :null
        expose :cover_image, format_with: :null
        expose :live_time,   format_with: :null
        expose :live_address, format_with: :null
        expose :body,         format_with: :null
        expose :stream_id, format_with: :null
        expose :view_count, :vod_url, :detail_images
        expose :type do |model, opts|
          2
        end
      end
      
      class LiveVideo < Base
        expose :title,       format_with: :null
        expose :cover_image, format_with: :null
        expose :live_time,   format_with: :null
        expose :live_address, format_with: :null
        expose :body,         format_with: :null
        expose :stream_id, format_with: :null
        expose :view_count, :rtmp_url, :hls_url, :type, :detail_images
      end
      
      # Banner
      class Banner < Base
        expose :image do |model, opts|
          model.image.blank? ? "" : model.image.url(:large)
        end
        expose :link, format_with: :null
      end
      
      # 产品
      class Product < Base
        expose :title, format_with: :null
        expose :price, format_with: :null
        expose :m_price, format_with: :null
        expose :category, using: API::V1::Entities::Category
        expose :stock, format_with: :null
        expose :on_sale
        expose :thumb_image do |model, opts|
          model.images.first.url(:small)
        end
      end
      
      # 产品详情
      class ProductDetail < Product
        expose :intro, format_with: :null
        expose :images do |model, opts|
          images = []
          model.images.each do |image|
            images << image.url(:large)
          end
          images
        end
        expose :detail_images do |model, opts|
          model.detail_images.map(&:url)
        end
      end
    
    end
  end
end
