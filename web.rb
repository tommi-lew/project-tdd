require_relative File.join('config', "shared.rb")

get '/' do
  Poller::poll(params[:station_no], params[:bus_no], true)
end
