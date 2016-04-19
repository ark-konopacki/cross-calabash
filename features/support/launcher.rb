# Defining android wrapper if platform enabled in profile
if ENV["PLATFORM"] == "android" || ENV["PLATFORM"] == "cross"
  require_relative './android/android_wrapper'
  android ||= AndroidWrapper
else
  android = nil
end

# Defining ios wrapper if platform enabled in profile
if ENV["PLATFORM"] == "ios" || ENV["PLATFORM"] == "cross"
  require_relative './ios/ios_wrapper'
  ios ||= IosWrapper
else
  ios = nil
end

# Before every scenario hook
Before do |scenario|
  # Scenario tags accessor
  scenario_tags = scenario.source_tag_names

  #Android launching part
  unless android.nil?
    android_launcher = Thread.new {
      android.prepare_device
      android.start_test_server_in_background
    }
  end

  #IOS launching part
  unless ios.nil?
    ios_launcher = Thread.new {
      ios.launch_app
    }
  end

  # Join platforms launching threads to main thread
  android_launcher.join unless android.nil?
  ios_launcher.join unless ios.nil?
end

# After every scenario hook
After do |scenario|
  # some stuff
end

# At exit hook runs after whole test suite finished
at_exit do

  # Android shot down part
  unless android.nil?
    android.shutdown_test_server
  end

  # iOS shot down part
  unless ios.nil?
    ios.shutdown_test_server
  end

end