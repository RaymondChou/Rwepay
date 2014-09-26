require "Rwepay/version"
require "Rwepay/common"
require 'json'

module Rwepay

  class JSPayment
    attr_accessor :configs
    attr_accessor :package_options
    attr_accessor :brand_options

    def initialize(configs = {})
      @configs = Rwepay::Common.configs_check configs,
                                              [:appid, :mch_id, :key]
    end

    def get_brand_request(options = {})
      package_options = Rwepay::Common.configs_check options,
                        [:body, :notify_url, :out_trade_no, :total_fee, :spbill_create_ip, :trade_type, :openid]

      # create package
      package_options[:key]       ||= @configs[:key]
      package_options[:appid]     ||= @configs[:appid]
      package_options[:mch_id]    ||= @configs[:mch_id]
      package_options[:nonce_str] ||= Rwepay::Common.get_nonce_str

      final_params = Hash.new
      final_params[:appId]     = package_options[:appid]
      final_params[:timeStamp] = Rwepay::Common.get_timestamps
      final_params[:nonceStr]  = Rwepay::Common.get_nonce_str

      succ, prepay_id = Rwepay::Common.get_prepay_id(package_options)

      final_params[:package]   = "prepay_id=#{prepay_id}"
      final_params[:signType]  = 'MD5'

      final_params[:paySign]   = Rwepay::Common.md5_sign(Rwepay::Common.create_sign_string(
          :appId     => final_params[:appId],
          :timeStamp => final_params[:timeStamp],
          :nonceStr  => final_params[:nonceStr],
          :package   => final_params[:package],
          :signType  => final_params[:signType],
          :key       => package_options[:key],
      ))

      return final_params.to_json, succ, prepay_id
    end

    def notify_verify?(xml)

      xml_object = Nokogiri::XML.parse(xml).xpath('xml')

      args = Hash.new

      xml_object.children.each do |node|
        args[node.name.to_s] = node.inner_text
      end

      args['key'] = @configs[:key]

      if args['return_code'] == "SUCCESS" and args['result_code'].inner_text == "SUCCESS"
        return Rwepay::Common.notify_sign(args) == args['sign'], args
      else
        return false, args
      end

    end

    def deliver_notify(options = {})
      options = Rwepay::Common.configs_check options,
                                             [:access_token, :open_id, :trans_id, :out_trade_no, :deliver_timestamp, :deliver_status, :deliver_msg]

      options[:appid]  = @configs[:appid]
      options[:app_key] = @configs[:app_key]

      Rwepay::Common.send_deliver_notify(options, options[:access_token])
    end

    def get_order_query(options = {})
      options = Rwepay::Common.configs_check options,
                                             [:access_token, :out_trade_no]

      options[:appid]      = @configs[:appid]
      options[:app_key]     = @configs[:app_key]
      options[:key] = @configs[:key]
      options[:mch_id]  = @configs[:mch_id]

      Rwepay::Common.get_order_query(options, options[:access_token])
    end

    # expire 7200 seconds, must be cached!
    def get_access_token(app_secret)
      begin
        response = Faraday.get("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{@configs[:appid]}&secret=#{app_secret}")
        response = JSON.parse response.body
        if response['access_token'] != nil
          response['access_token']
        else
          false
        end
      rescue
        false
      end
    end

    def update_feedback(options = {})
      options = Rwepay::Common.configs_check options,
                                             [:access_token, :open_id, :feedback_id]
      begin
        response = Faraday.get("https://api.weixin.qq.com/payfeedback/update?access_token=#{options[:access_token]}&openid=#{options[:open_id]}&feedbackid=#{options[:feedback_id]}")
        response = JSON.parse response.body
        if response['errcode'] == 0
          true
        else
          false
        end
      rescue
        false
      end
    end

  end

  # @TODO
  class NativePayment

  end

end
