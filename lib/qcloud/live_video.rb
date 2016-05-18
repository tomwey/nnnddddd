require 'rest-client'
require 'openssl'
require 'base64'
module Qcloud
  class LiveVideo
    # 创建直播
    def self.create_channel(live_video)
      return false if live_video.blank?
      # params = {
      #   'Action'            => 'CreateLVBChannel',
      #   'Timestamp'         => "#{Time.now.to_i}",
      #   'Nonce'             => SecureRandom.hex(8),
      #   'SecretId'          => Setting.qcloud_api_key,
      #   'channelName'       => live_video.title,
      #   'channelDescribe'   => live_video.body,
      #   'outputSourceType'  => 3,
      #   # 'playerPassword'    => nil,
      #   'sourceList.1.name' => "zgnx_video_#{live_video.id || 1}",
      #   'sourceList.1.type' => 1,
      # }
      #
      # sign_str = sign_string_for(Setting.qcloud_live_api, 'GET', params)
      #
      # api_secret = Setting.qcloud_api_secret
      # hash_hmac = OpenSSL::HMAC.digest('sha1', api_secret, sign_str)
      # sign = Base64.encode64(hash_hmac)
      # query_str = params.map { |k,v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')
      #
      # resp = RestClient.get "https://#{Setting.qcloud_live_api}?#{query_str}&Signature=#{CGI.escape(sign)[0..-4]}", :accept => :json
      params = {
        'Action'            => 'CreateLVBChannel',
        'channelName'       => live_video.title,
        'channelDescribe'   => live_video.body,
        'outputSourceType'  => 3,
        # 'playerPassword'    => nil,
        'sourceList.1.name' => "zgnx_video_#{live_video.id || 1}",
        'sourceList.1.type' => 1,
      }
      self.send_request('GET', Setting.qcloud_live_api, params)

    end
    
    # 获取直播详情
    def self.fetch_channel_detail(channel_id)
      params = {
        'Action'    => 'DescribeLVBChannel',
        'channelId' => channel_id.to_i,
      }
      self.send_request('GET', Setting.qcloud_live_api, params)
    end
    
    # 批量开启直播
    def self.open_channels(channel_ids)
      return false if channel_ids.blank? or channel_ids.empty?
      params = {
        'Action' => 'StartLVBChannel',
      }
      channel_ids.each_with_index do |channel_id, index|
        params["channelIds.#{index+1}"] = channel_id
      end
      
      result = self.send_request('GET', Setting.qcloud_live_api, params)
      return result['code'].to_i == 0
    end
    
    # 批量关闭直播
    def self.close_channels(channel_ids)
      return false if channel_ids.blank? or channel_ids.empty?
      params = {
        'Action' => 'StopLVBChannel',
      }
      channel_ids.each_with_index do |channel_id, index|
        params["channelIds.#{index+1}"] = channel_id
      end
      
      result = self.send_request('GET', Setting.qcloud_live_api, params)
      return result['code'].to_i == 0
    end
    
    protected
    def self.send_request(method, api_host, params)
      # 公共参数
      comm_params = {
        'Timestamp' => "#{Time.now.to_i}",
        'Nonce'     => SecureRandom.hex(8),
        'SecretId'  => Setting.qcloud_api_key,
      }
      
      # 合并参数
      new_params = comm_params.merge(params)
      
      # 参数签名
      sign_str = sign_string_for(api_host, method, new_params)
      api_secret = Setting.qcloud_api_secret
      hash_hmac = OpenSSL::HMAC.digest('sha1', api_secret, sign_str)
      sign = Base64.encode64(hash_hmac)

      if method == 'GET'
        query_str = new_params.map { |k,v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')
        resp = RestClient.get "https://#{api_host}?#{query_str}&Signature=#{CGI.escape(sign)[0..-4]}", :accept => :json
      elsif method == 'POST'
        # 没有调通POST请求
        # query_str = new_params.map { |k,v| "#{k}=#{v}" }.join('&')
        # resp = RestClient.post "https://#{api_host}?Action=#{new_params['Action']}&Signature=#{CGI.escape(sign)[0..-4]}", new_params.to_json, { :content_type => :json }
      end
      
      result = JSON.parse(resp)
      result
    end
    
    def self.sign_string_for(api_url, method, params)
      arr = params.sort
      hash = Hash[*arr.flatten]
      params_str = hash.delete_if { |k,v| v.blank? }.map { |k,v| "#{k}=#{v}" }.join('&')
      result = method + api_url + '?' + params_str
      result
    end
    
  end
  
end