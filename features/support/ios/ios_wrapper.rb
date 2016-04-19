require 'calabash-cucumber'
require 'calabash-cucumber/operations'
require 'calabash-cucumber/http_helpers'
require_relative './ios_launcher'
require_relative './ios_http_helpers'
# IOS library wrapper
module IosWrapper
  extend Calabash::Cucumber::Operations
  module_function

  @@device = ENV['DEVICE_TARGET']
  @@app_path = ENV['IOS_APP_PATH']
  @@bundle_id = 'your Bundle ID'

  # @return {String} device
  def get_device_uid
    if @@device != nil && @@device != ''
      if `instruments -s devices | grep '#{@@device}'`.delete("\n") == ''
        @@device = `idevice_id -l`.delete("\n")
      end
    else
      @@device = `idevice_id -l`.delete("\n")
    end
    ENV['DEVICE_TARGET'] = @@device
    @@device
  end

  # Launch app
  def launch_app
    @@launcher = Launcher.new
    options = {
        :app => @@app_path,
        :bundle_id => @@bundle_id
    }
    @@launcher.relaunch(options)
    @@launcher.calabash_notify(self)
    @@launcher.ensure_connectivity
  end

end