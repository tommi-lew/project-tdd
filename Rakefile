require_relative File.join('config', "shared.rb")

class String
  #git://gist.github.com/2000623.git
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

desc 'Poll for the frequency of the bus'
task :get_arrival, :station_no, :bus_no, :is_test do |t, args|
  is_test = args[:is_test].to_bool
  Poller::poll(args[:station_no], args[:bus_no], is_test)
end


