module API
  module V1
    class Root < Grape::API
      version 'v1'
      
      helpers API::CommHelpers
      helpers API::SharedParams
      
      mount API::V1::Welcome
      mount API::V1::FeedbacksAPI
      mount API::V1::CategoriesAPI
      mount API::V1::AuthCodesAPI
      mount API::V1::UsersAPI
      mount API::V1::BannersAPI
      mount API::V1::VideosAPI
      # 
      # 配合trix文本编辑器
      # mount API::V1::AttachmentsAPI
      
      # 开发文档配置
      add_swagger_documentation(
          :api_version => "api/v1",
          hide_documentation_path: true,
          # mount_path: "/api/v1/api_doc",
          hide_format: true
      )
      
    end
  end
end