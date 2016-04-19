require 'calabash-cucumber/launcher'

# IOS launcher
class Launcher < Calabash::Cucumber::Launcher

  # @!visibility private
  # Supporting method overwriting to handle different device targets values
  def ping_app
    url = URI.parse(ENV['IOS_DEVICE_ENDPOINT']|| "http://localhost:37265/")
    http = Net::HTTP.new(url.host, url.port)
    res = http.start do |sess|
      sess.request Net::HTTP::Get.new(ENV['CALABASH_VERSION_PATH'] || "version")
    end
    status = res.code

    http.finish if http and http.started?

    if status == '200'
      version_body = JSON.parse(res.body)
      self.device = Calabash::Cucumber::Device.new(url, version_body)
    end

    status
  end
end