module API
  module V1
    class SearchAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :search, desc: '搜索接口' do
        desc "热门关键字"
        params do
          optional :size, type: Integer, desc: '获取热门关键的数量，默认为8'
        end
        get :hot_keywords do
          size = params[:size].blank? ? 8 : params[:size].to_i
          @searches = Search.order('search_count desc').limit(size)
          render_json(@searches, API::V1::Entities::Search)
        end # end hot_keywords
        
        desc "关键字自动补全"
        params do
          requires :q, type: String, desc: "关键字，必须"
        end
        get :kw_list do
          @searches = Search.kw_search(params[:q].strip)
          render_json(@searches, API::V1::Entities::Search)
        end # end
         
        desc "根据关键字搜索视频"
        params do
          requires :q, type: String, desc: "关键字，必须"
          use :pagination
        end
        get do
          keyword = params[:q].strip
          @search = Search.where(keyword: keyword).first_or_create
          unless @search.blank?
            @search.add_search_count
          end
          
          @videos = Video.search(keyword)
          if params[:page]
            @videos = @videos.paginate page: params[:page], per_page: page_size
          end
          
          render_json(@videos, API::V1::Entities::Video)
        end # end get
      end # end resource
      
    end
  end
end