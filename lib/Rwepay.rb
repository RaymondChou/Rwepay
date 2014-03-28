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
  end

  class NativePayment

  end

end
