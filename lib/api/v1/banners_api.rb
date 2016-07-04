module API
  module V1
    class BannersAPI < Grape::API
      
      resource :banners, desc: "广告接口" do
        desc '获取广告列表'
        params do
          optional :size,  type: Integer, desc: '获取的广告条数'
        end
        get do
          size = params[:size].blank? ? 5 : params[:size].to_i 
          @banners = Banner.where(category_id: nil).sorted.recent.limit(size)
          render_json(@banners, API::V1::Entities::Banner)
        end
      end # end resource
      
    end
  end
end