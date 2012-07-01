require 'data_mapper'
require 'net/http'

class Poller
  def self.poll(station_no, bus_no, is_test=false)
    time_now = Time.now
    puts "Attempting to get bus arrival time at #{time_now.to_s}..."
    return "off" if time_now.hour >= 1 && time_now.hour <= 6

    puts "Invoking endpoint for svc:#{bus_no} & busstop:#{station_no}"

    response = "fake response"

    if !is_test
      endpoint_url = "http://www.sbstransit.com.sg/iris_api/nextbus.aspx?svc=#{bus_no}&busstop=#{station_no}&iriskey=#{ENV['SBS_TRANSIT_API_KEY']}"
      uri = URI(endpoint_url)

      req = Net::HTTP::Get.new(uri.request_uri)
      req['User-Agent'] = "SBSTransitIris/81 CFNetwork/548.1.4 Darwin/11.0.0"
      req['Accept'] = "*/*"
      req['Accept-Language'] = "en-gb"
      req['Cookie'] = "rl-sticky-key=c0a80899"
      req['Pragma'] = "no-cache"
      req['Connection'] = "keep-alive"
      req['Proxy-Connection'] = "keep-alive"
      req.delete('Content')

      response = Net::HTTP.start(uri.hostname, uri.port) { |http|
        http.request(req)
      }
    end

    puts "Response: #{response}"

    new_record = BusArrival.new(
      :poll_at => Time.now.to_i.to_s,
      :station_no => station_no,
      :bus_no => bus_no,
      :result => response,
      :is_test => is_test
    )
    new_record.save
  end
end
