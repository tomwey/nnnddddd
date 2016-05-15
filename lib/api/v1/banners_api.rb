module API
  module V1
    class BannersAPI < Grape::API
      
      resource :banners do
        get do
          @banners = Banner.sorted.recent.limit(5)
          render_json(@banners, API::V1::Entities::Banner)
        end
      end # end resource
      
    end
  end
end