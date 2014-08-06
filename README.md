# Rwepay

[![Build Status](https://travis-ci.org/RaymondChou/Rwepay.svg?branch=master)](https://travis-ci.org/RaymondChou/Rwepay)

 微信支付 Wechat Pay Ruby SDK Gem

 [Ralipay(支付宝PaymentGem)](https://github.com/RaymondChou/ralipay)姊妹篇，微信支付SDK

 示例中的账号信息是微信提供的测试数据，你需要使用自己的账号信息才可以完成测试：）

 注：测试期间（未上线状态）你需要在微信商户后台设定的域名下进行测试，测试域名只能在当前公众号会话内测试才有效，并且加好测试微信账号的白名单，否则JSAPI会报access_control:not_allow

 具体参见[微信API文档](https://mp.weixin.qq.com/htmledition/res/bussiness-course2/wxpay-payment-api.pdf)

 特别要注意的一点，千万不要将微信提供的js demo使用在产品环境，那是非常不安全的。notify回调校验请严格使用notify_verify?方法进行。

## Installation

Add this line to your application's Gemfile:

    gem 'Rwepay'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install Rwepay

## Usage

### JSPayment

- 初始化 [new]

		configs = {
        	:app_id => 'wxf8b4f85f3a794e77',
        	:partner_id => '1900000109',
        	:app_key => 'xxxx',
        	:partner_key => '8934e7d15453e97507ef794cf7b0519d'
		}
		payment = Rwepay::JSPayment.new configs

- 创建支付请求 [get_brand_request]
options参数用于构建package，示例中写了必填参数，可选参数也可使用hash方式传入，参见文档。

In Controller:

	options = {
        :body => '测试商品',
        :notify_url => 'http://domain.com/to/path',
        :out_trade_no => 'TEST123456',
        :total_fee => '1',
        :spbill_create_ip => '127.0.0.1',
	}
	@brand_json = js_payment.get_brand_request(options)

In View:

	<%= link_to '微信支付', "javascript:void(0)", :id => 'wechat'  %>
	<script Language="javascript">
	    document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
	    	$('#wechat').click(function(){
	    		WeixinJSBridge.invoke('getBrandWCPayRequest', <%= raw @brand_json %>,function(res){
					if(res.err_msg == "get_brand_wcpay_request:ok" ) {
						alert('支付成功!');
					}else{
						alert(res.err_msg);
					}
				});
			});
		}, false);
	</script>

- 回调验证 [notify_verify?]

		status = payment.notify_verify?(params)
		if status
			#这里请自行验证params[:total_fee]的值与订单是否相符，按需要存储其他内容特别是transaction_id
			render :text => 'success'
		else
			render :text => 'fail'
		end

- 发货通知 [deliver_notify]

此接口调用需传入开放平台的access_token，由于access_token有时限且有请求限制，需要自行获取并按7200秒缓存，可使用下方的get_access_token方法

	options = {
		:access_token => access_token,
		:open_id => 'oVGDVjni9uU30O9TGrlIWp-BcuYw',
		:trans_id => '1217737101201403308373364651',
		:out_trade_no => '1246154588',
		:deliver_timestamp => Time.now.to_i.to_s,
		:deliver_status => '1',
		:deliver_msg => 'ok'
	}
	status, error = js_payment.deliver_notify(options)

- 获取订单状态 [get_order_query]

		options = {
			:access_token => access_token,
	    	:out_trade_no => '1246154588'
		}
		status, response = js_payment.get_order_query(options)
	
- 获取access_token [get_access_token]

		access_token = js_payment.get_access_token('your app_secret hear')

- 更新维权信息 [update_feedback]

    options = {
            :access_token => access_token,
            :open_id      => open_id,
            :feedback_id  => feedback_id
    }
    js_payment.update_feedback(options)

### NativePayment

  TODO

## Contributing

1. Fork it ( http://github.com/RaymondChou/Rwepay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request