Then(/^app is launched on Android$/) do
  android = AndroidBase.new(self)
  android.wait_for_element_exists("*")
end
