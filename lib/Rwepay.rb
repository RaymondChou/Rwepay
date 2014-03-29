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
                                              [:app_id, :partner_id, :app_key, :partner_key]
    end

    def get_brand_request(options = {})
      brand_options = Rwepay::Common.configs_check options,
                                                   [:body, :notify_url, :out_trade_no, :total_fee, :spbill_create_ip]

      # create package
      brand_options[:key]       ||= @configs[:partner_key]
      brand_options[:partner]   ||= @configs[:partner_id]
      brand_options[:fee_type]  ||= '1'
      brand_options[:bank_type] ||= 'WX'
      brand_options[:input_charset] ||= 'GBK'

      final_params = Hash.new
      final_params[:appId]     = @configs[:app_id]
      final_params[:timeStamp] = Rwepay::Common.get_timestamps
      final_params[:nonceStr]  = Rwepay::Common.get_nonce_str
      final_params[:package]   = Rwepay::Common.get_package(brand_options)
      final_params[:signType]  = 'SHA1'
      final_params[:paySign]   = Rwepay::Common.pay_sign(
          :appid     => @configs[:app_id],
          :appkey    => @configs[:app_key],
          :noncestr  => final_params[:nonceStr],
          :package   => final_params[:package],
          :timestamp => final_params[:timeStamp],
      )
      final_params.to_json
    end

    def notify_verify?(params = {})
      params['key'] ||= @configs[:partner_key]
      Rwepay::Common.notify_sign(params) == params['sign'] and params['trade_state'] == '0'
    end

    def deliver_notify(options = {})
      options = Rwepay::Common.configs_check options,
                [:access_token, :open_id, :trans_id, :out_trade_no, :deliver_timestamp, :deliver_status, :deliver_msg]

      options[:app_id]  = @configs[:app_id]
      options[:app_key] = @configs[:app_key]

      Rwepay::Common.send_deliver_notify(options, options[:access_token])
    end

    def get_order_query(options = {})
      options = Rwepay::Common.configs_check options,
                [:access_token, :out_trade_no]

      options[:app_id]      = @configs[:app_id]
      options[:app_key]     = @configs[:app_key]
      options[:partner_key] = @configs[:partner_key]
      options[:partner_id]  = @configs[:partner_id]

      Rwepay::Common.get_order_query(options, options[:access_token])
    end


  end

  # @TODO
  class NativePayment

  end

end
