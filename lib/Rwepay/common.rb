module Rwepay::Common

  require 'digest/sha1'
  require 'digest/md5'
  require 'securerandom'

  def self.configs_check(configs = {}, requires = [])
    requires.each do |require|
      unless configs.include? require
        raise "Rwepay Error, configs required hash symbol :#{require}"
      end
    end
    configs
  end

  def self.get_nonce_str
    SecureRandom.hex 32
  end

  def self.create_sign_string(sign_params = {}, sort = true)
    #对原串进行签名，注意这里不要对任何字段进行编码。这里是将参数按照key=value进行字典排序后组成下面的字符串,在这个字符串最后拼接上key=XXXX。由于这里的字段固定，因此只需要按照这个顺序进行排序即可。

    result_string = ''
    #是否排序
    if sort
      sign_params = sign_params.sort
    end

    sign_params.each{|key,value|
      result_string += (key.to_s + '=' + value.to_s + '&') if key.to_s != 'key'
    }

    "#{result_string}key=#{sign_params[:key]}"
  end

  def self.md5_sign(for_sign_string)
    Digest::MD5.hexdigest(for_sign_string).upcase
  end

  def self.sha1_sign(for_sign_string)
    Digest::SHA1.hexdigest(for_sign_string)
  end

  def self.result_params_filter(sign_params)
    result_string = ''
    #是否排序
    if sort
      sign_params = sign_params.sort
    end

    sign_params.each{|key,value|
      result_string += (key.to_s + '=' + value.to_s + '&') if key.to_s != 'key'
    }
    #去掉末尾的&
    result_string = result_string[0, result_string.length - 1]
    return result_string
  end

  #get_package :bank_type, :body, :fee_type, :input_charset, :notify_url, :out_trade_no, :partner, :spbill_create_ip, :total_fee, :key
  def self.get_package(sign_params = {})
    for_sign_string   = create_sign_string sign_params
    md5_signed_string = md5_sign for_sign_string
    result_params     = result_params_filter sign_params

    "#{result_params}&sign=#{md5_signed_string}"
  end

  #sign_string :appid, :appkey, :noncestr, :package, :timestamp
  def self.pay_sign(sign_params = {})
    for_sign_string    = create_sign_string sign_params
    sha1_signed_string = sha1_sign for_sign_string
    sha1_signed_string
  end

  def self.get_timestamps
    Time.now.to_i.to_s
  end

end
