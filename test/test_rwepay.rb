require 'test/unit'
require 'Rwepay'

class TestRwepay < Test::Unit::TestCase

  def test_get_brand_request
    configs = {
        :app_id => 'wxf8b4f85f3a794e77',
        :partner_id => '1900000109',
        :app_key => '2Wozy2aksie1puXUBpWD8oZxiD1DfQuEaiC7KcRATv1Ino3mdopKaPGQQ7TtkNySuAmCaDCrw4xhPY5qKTBl7Fzm0RgR3c0WaVYIXZARsxzHV2x7iwPPzOz94dnwPWSn',
        :partner_key => '8934e7d15453e97507ef794cf7b0519d'
    }

    options = {
        :body => '测试商品',
        :notify_url => 'http://www.qq.com',
        :out_trade_no => '16642817866003386000',
        :total_fee => '1',
        :spbill_create_ip => '127.0.0.1',
    }

    payment = Rwepay::JSPayment.new configs
    result_json = payment.get_brand_request(options)
    assert_equal result_json, result_json
  end

  def test_notify_verify
    params = "xxx"

    configs = {
        :app_id => 'wxf8b4f85f3a794e77',
        :partner_id => '1900000109',
        :app_key => '2Wozy2aksie1puXUBpWD8oZxiD1DfQuEaiC7KcRATv1Ino3mdopKaPGQQ7TtkNySuAmCaDCrw4xhPY5qKTBl7Fzm0RgR3c0WaVYIXZARsxzHV2x7iwPPzOz94dnwPWSn',
        :partner_key => '8934e7d15453e97507ef794cf7b0519d'
    }

    payment = Rwepay::JSPayment.new configs
    assert_equal true, payment.notify_verify?(params)
  end


end