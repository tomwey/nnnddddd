module API
  module V1
    class GrantsAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :grants, desc: '打赏相关的接口' do
        desc '创建一个打赏'
        params do
          requires :token,        type: String,  desc: '用户认证Token'
          requires :pay_password, type: String,  desc: '支付密码'
          requires :money,        type: BigDecimal, desc: '打赏金额，单位为元'
          optional :to,           type: Integer, desc: '被打赏的用户ID，如果是打赏给平台，那么可以不传该参数'
        end
        post do
          user = authenticate!
          
          decode_pass = Base64.decode64(params[:pay_password])
          pass_secret = decode_pass[0..127]
          real_pass = decode_pass[128..-1]
          unless ( pass_secret == Setting.pass_secret && user.is_pay_password?(real_pass) )
            return render_error(7001, '支付密码不正确')
          end
          
          if params[:money] < 0.1
            return render_error(7002, '至少需要打赏一角钱')
          end
          
          money = params[:money]#.to_i / 100.00
          if user.balance < money
            return render_error(7003, '余额不足，请充值后再操作')
          end
          
          to_user = User.find_by(id: params[:to])
          
          User.transaction do
            Grant.create!(from: user.id, money: money, to: to_user.try(:id))
            
            # 减去打赏者的余额
            user.grant_money!(-money)
            # 记录交易明细
            PayHistory.create!(pay_name: '打赏别人', 
                               pay_type: PayHistory::PAY_TYPE_GRANT, 
                               money: money,
                               user_id: user.id)
            
            # 增加被打赏者的余额
            to_user.grant_money!(money) if to_user.present?
            if to_user.present?
              # 记录交易明细
              PayHistory.create!(pay_name: '收到打赏', 
                                 pay_type: PayHistory::PAY_TYPE_GRANT, 
                                 money: money,
                                 user_id: to_user.id)
            end
            
          end
          render_json_no_data
        end # end post
        
        desc '发出的打赏'
        params do
          requires :token, type: String, desc: '认证Token'
          use :pagination
        end
        get :sent do
          user = authenticate!
          
          @grants = Grant.where(from: user.id).order('id desc')
          @grants = @grants.paginate(page: params[:page], per_page: page_size) if params[:page]
          render_json(@grants, API::V1::Entities::SentGrant)
          
        end # end get sent
        
        desc '收到的打赏'
        params do
          requires :token, type: String, desc: '认证Token'
          use :pagination
        end
        get :receipt do
          user = authenticate!
          
          @grants = Grant.where(to: user.id).order('id desc')
          @grants = @grants.paginate(page: params[:page], per_page: page_size) if params[:page]
          render_json(@grants, API::V1::Entities::ReceiptGrant)
          
        end # end get receipt
        
      end # end resource
      
    end
  end
end