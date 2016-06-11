module API
  module V1
    module Entities
      class Base < Grape::Entity
        format_with(:null) { |v| v.blank? ? "" : v }
        format_with(:chinese_date) { |v| v.blank? ? "" : v.strftime('%Y-%m-%d') }
        format_with(:chinese_datetime) { |v| v.blank? ? "" : v.strftime('%Y-%m-%d %H:%M:%S') }
        format_with(:money_format) { |v| v.blank? ? 0 : ('%.2f' % v).to_f }
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
        expose :sent_money, format_with: :money_format
        expose :receipt_money, format_with: :money_format
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
        expose :body, format_with: :null
        expose :cover_image do |model, opts|
          model.cover_image.blank? ? "" : model.cover_image.url(:large)
        end
        expose :type
        expose :view_count, :likes_count, :msg_count
        expose :stream_id, format_with: :null
        expose :created_on do |model, opts|
          model.created_at.blank? ? "" : model.created_at.strftime('%Y-%m-%d')
        end
        expose :liked do |model, opts|
          if opts[:opts].blank?
            false
          elsif opts[:opts][:liked].present?
            opts[:opts][:liked]
          else
            opts[:opts][:liked_user].blank? ? false : opts[:opts][:liked_user].liked?(model)
          end
        end
      end
      
      class Search < Base
        expose :keyword, :search_count
      end
      
      class Video < SimpleVideo
        expose :video_file do |model, opts|
          model.file_url#model.file.blank? ? "" : model.file.url#model.file.url(:mp4)
        end
        expose :category, using: API::V1::Entities::Category
        expose :user,     using: API::V1::Entities::UserProfile, if: Proc.new { |video| video.user_id > 0 }
      end
      
      class LiveSimpleVideo < SimpleVideo
        expose :video_file do |model, opts|
          model.video_file_url# model.video_file.blank? ? "" : model.video_file.url#model.file.url(:mp4)
        end
      end
      
      class LiveVideo < LiveSimpleVideo
        expose :rtmp_url, :hls_url
        expose :online_users_count, as: :view_count
      end
      
      class Author < Base
        expose :nickname do |model, opts|
          model.nickname || model.mobile
        end
        expose :avatar do |model, opts|
          model.avatar.blank? ? "" : model.avatar_url(:large)
        end
      end
      
      class Bilibili < Base
        expose :content, format_with: :null
        expose :stream_id, format_with: :null
        # expose :author_name, as: :author
        expose :author, using: API::V1::Entities::Author, if: Proc.new { |b| b.author_id.present? }
        expose :location, format_with: :null
        expose :created_at, as: :sent_at, format_with: :chinese_datetime
      end
      
      # Banner
      class Banner < Base
        expose :image do |model, opts|
          model.image.blank? ? "" : model.image.url(:large)
        end
        expose :link, format_with: :null
      end
      # 打赏相关
      class Grant < Base
        expose :money, format_with: :money_format
        expose :created_at, format_with: :chinese_datetime
      end
      
      class SentUserProfile < UserProfile
        expose :sent_money, format_with: :money_format
      end
      
      class ReceiptUserProfile < UserProfile
        expose :receipt_money, format_with: :money_format
      end
      
      class SentGrant < Grant
        expose :granted_user, as: :user, using: API::V1::Entities::UserProfile#, if: Proc.new { |u| u.present? }
      end
      
      class ReceiptGrant < Grant
        expose :granting_user, as: :user, using: API::V1::Entities::UserProfile#, if: Proc.new { |u| u.present? }
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
