# Rwepay

[![Build Status](https://travis-ci.org/RaymondChou/Rwepay.svg?branch=master)](https://travis-ci.org/RaymondChou/Rwepay)

微信支付 Wechat Pay Ruby SDK Gem

## Installation

Add this line to your application's Gemfile:

    gem 'Rwepay'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install Rwepay

## Usage

 [Ralipay(支付宝PaymentGem)](https://github.com/RaymondChou/ralipay)姊妹篇，微信支付SDK

 示例中的账号信息是微信提供的测试数据，你需要使用自己的账号信息才可以完成测试：）

 具体参见[微信API文档](https://mp.weixin.qq.com/htmledition/res/bussiness-course2/wxpay-payment-api.pdf)

 特别要注意的一点，千万不要将微信提供的js demo使用在产品环境，那是非常不安全的。notify回调校验请严格使用notify_verify?方法进行。

## Contributing

1. Fork it ( http://github.com/RaymondChou/Rwepay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
