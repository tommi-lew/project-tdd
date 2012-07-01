require 'spec_helper'

describe Poller do
  MOCK_RESPONSE =
    '<?xml version="1.0" encoding="iso-8859-1"?><iris><result><service_no>124</service_no><nextbus><t>0</t><wab>1</wab></nextbus><subsequentbus><t>9</t><wab>1</wab></subsequentbus></result><result><service_no>124A</service_no><nextbus><t>-2</t><wab>0</wab></nextbus><subsequentbus><t>-2</t><wab>0</wab></subsequentbus></result></iris>'

  def assert_poll_response(station_no, bus_no, is_test, expected_response)
    response = Poller.poll(station_no, bus_no, is_test)
    response.should == expected_response
  end

  describe '#poll' do
    it 'should return fake response when is_test is true' do
      assert_poll_response(01234, 89, true, "fake response")
    end

    it 'should return off when time is between 1am and 6am' do
      Timecop.freeze(Time.new(2012, nil, nil, 2)) do
        assert_poll_response(01234, 89, false, 'off')
      end
    end

    it 'should return fake response when is_test is true and time is between 1am and 6am' do
      Timecop.freeze(Time.new(2012, nil, nil, 2)) do
        assert_poll_response(01234, 89, true, 'fake response')
      end
    end

    it 'should invoke API when is_test is false' do
      stub_request(:any, /sbstransit.com.sg/).to_return(:body => MOCK_RESPONSE)
      Timecop.freeze(Time.new(2012, nil, nil, 8)) do
        assert_poll_response(01234, 89, false, MOCK_RESPONSE)
      end
    end
  end

  describe '#create_request' do
    it 'should return a Net::HTTP:Get with headers' do
      req = Poller.create_request(URI("http://a.com/b=c"))
      req.should be_kind_of(Net::HTTP::Get)
      req['User-Agent'].should == "SBSTransitIris/81 CFNetwork/548.1.4 Darwin/11.0.0"
      req['Accept'].should == "*/*"
      req['Accept-Language'].should == "en-gb"
      req['Cookie'].should == "rl-sticky-key=c0a80899"
      req['Pragma'].should == "no-cache"
      req['Connection'].should == "keep-alive"
      req['Proxy-Connection'].should == "keep-alive"
      req['Content'].should be_nil
    end
  end
end

