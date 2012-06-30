require_relative File.join('config', "shared.rb")

desc 'Poll for the frequency of the bus'
task :get_arrival, :station_no, :bus_no do |t, args|
  Poller::poll(args[:station_no], args[:bus_no])
end
