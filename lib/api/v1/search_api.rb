module API
  module V1
    class SearchAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :hot_searches, desc: "猜你喜欢，返回热搜的直播或视频" do
        desc "猜你喜欢，返回一定数量的记录"
        params do
          optional :size, type: Integer, desc: '热搜的数据记录数'
          optional :type, type: Integer, desc: '视频类别，值为1或者2，如果为1表示直播，2表示推荐的点播'
          optional :token,type: String,  desc: '认证Token'
        end
        get do
          type = params[:type].blank? ? 2 : params[:type].to_i
          type = 2 if type < 1 or type > 2
          
          if type == 1
            searchable_type = 'LiveVideo'
          else
            searchable_type = 'Video'
          end
          
          klass = searchable_type.classify.constantize
          
          size = params[:size].blank? ? 8 : params[:size].to_i
          
          if type == 1
            @searchables = klass.order('search_count desc').limit(size)
          else
            @searchables = klass.approved.order('search_count desc').limit(size)
          end
          
          user = params[:token].blank? ? nil : User.find_by(private_token: params[:token])
          render_json(@searchables, API::V1::Entities::Stream, { user: user })
          
        end # end
      end # end resource 
      
      resource :search, desc: '搜索接口' do
        desc "热门关键字"
        params do
          optional :size, type: Integer, desc: '获取热门关键的数量，默认为8'
          optional :type, type: Integer, desc: '视频类别，值为1或者2，如果为1表示直播，2表示推荐的点播'
        end
        get :hot_keywords do
          size = params[:size].blank? ? 8 : params[:size].to_i
          type = params[:type].blank? ? 2 : params[:type].to_i
          @searches = Search.where(video_type: type).hot.limit(size)
          render_json(@searches, API::V1::Entities::Search)
        end # end hot_keywords
        
        desc "关键字自动补全"
        params do
          requires :q, type: String, desc: "关键字，必须"
        end
        get :kw_list do
          @searches = Search.kw_search(params[:q].strip).hot
          render_json(@searches, API::V1::Entities::Search)
        end # end
         
        desc "根据关键字搜索视频"
        params do
          requires :q,     type: String, desc: "关键字，必须"
          optional :token, type: String, desc: 'Token'
          optional :type,  type: Integer, desc: '视频类别，1表示直播，2表示推荐视频'
          use :pagination
        end
        get do
          keyword = params[:q].strip
          type = params[:type].blank? ? 2 : params[:type].to_i
          type = 2 if type < 1 or type > 2
          
          # 记录搜索关键字信息
          @search = Search.where(keyword: keyword, video_type: type).first_or_create
          unless @search.blank?
            @search.add_search_count
          end
          
          # 开始搜索
          if type == 1
            searchable_type = 'LiveVideo'
          else
            searchable_type = 'Video'
          end
          
          klass = searchable_type.classify.constantize
          
          if type == 1
            @searchables = klass.search(keyword)
          else
            @searchables = klass.approved.search(keyword)
          end
          
          if params[:page]
            @searchables = @searchables.paginate page: params[:page], per_page: page_size
          end
          
          # TODO 考虑以后放到队列里面处理
          # 记录搜索历史
          @searchables.to_a.each do |searchable|
            # 每个被搜索对象会统计搜索次数
            searchable.add_search_count
            # 单个搜索历史也需要统计搜索次数
            sh = SearchHistory.where(search_id: @search.id, searchable_type: searchable.class, searchable_id: searchable.id).first_or_create
            unless sh.blank?
              sh.add_search_count
            end
          end
          
          user = params[:token].blank? ? nil : User.find_by(private_token: params[:token])
          render_json(@searchables, API::V1::Entities::Stream, { user: user })
        end # end get
      end # end resource
      
    end
  end
end