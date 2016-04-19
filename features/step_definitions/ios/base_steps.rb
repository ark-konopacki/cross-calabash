Then /^app is launched on IOS$/ do
  ios = IosBase.new(self)
  ios.wait_for_element_exists("UIView")
end