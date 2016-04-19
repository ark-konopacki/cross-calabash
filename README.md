# cross-calabash
Cross platform calabash example 

# Before you can run tests you should define variables in
**features/support/env.rb**

#Android
ENV['ANDROID_APP_PATH'] = 'Path to you Android apk file'

#iOS
ENV['IOS_APP_PATH'] = 'Path to you iOS app file'
ENV['DEVICE_TARGET'] = 'your_device_UDID'
ENV['IOS_DEVICE_ENDPOINT'] = 'http://IP_OF_DEVICE:37265'

**features/support/ios/ios_wrapper.rb**
@@bundle_id = 'your app Bundle ID'

After that you can run tests as simple as:
`bundle exec cucumber`

