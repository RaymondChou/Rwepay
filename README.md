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

  - 创建支付请求 [get_brand_request]

  - 回调验证 [notify_verify?]

  - 发货通知 [deliver_notify]

  - 获取订单状态 [get_order_query]

  - 获取access_token [get_access_token]

  ### NativePayment

  TODO

## Contributing

1. Fork it ( http://github.com/RaymondChou/Rwepay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
