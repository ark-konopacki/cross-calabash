require 'calabash-android'
require 'calabash-android/operations'
require 'calabash-android/helpers'
require_relative './android_helpers'
# Android library wrapper
module AndroidWrapper
    extend Calabash::Android::Operations
    module_function

    # Prepare device for tests
    def prepare_device
      app_path = ENV['ANDROID_APP_PATH']
      spec = Gem::Specification.find_by_name("calabash-android")
      build_script_file = File.join(spec.gem_dir,'/bin/calabash-android-build.rb')
      require build_script_file
      # if needed uncomment resigning app
      # resign_apk(app_path)
      build_test_server_if_needed(app_path)
      @@device = Calabash::Android::Operations::Device.new(self, nil, nil, app_path, test_server_path(app_path))
      set_default_device(@@device)
    end

    # @return {Object}
    def device
      @@device
    end

end
