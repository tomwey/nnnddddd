module API
  module V1
    module Entities
      class Base < Grape::Entity
        format_with(:null) { |v| v.blank? ? "" : v }
        format_with(:chinese_datetime) { |v| v.blank? ? "" : v.strftime('%Y-%m-%d %H:%M:%S') }
        expose :id
        # expose :created_at, format_with: :chinese_datetime
      end # end Base
      
      # 用户详情
      class User < Base
        expose :private_token, as: :token, format_with: :null
        expose :mobile, format_with: :null
        expose :nickname do |model, opts|
          model.nickname || model.mobile
        end
        expose :avatar do |model, opts|
          model.avatar.blank? ? "" : model.avatar_url(:large)
        end
      end
      
      # 类别详情
      class Category < Base
        expose :name, format_with: :null
        expose :image do |model, opts|
          model.image.blank? ? "" : model.image.url(:thumb)
         end
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
