# Calabash
module Calabash
  # Cucumber
  module Cucumber
    # Workaround for DEVICE_ENDPOINT
    module HTTPHelpers
      extend Calabash::Cucumber::HTTPHelpers

      # @!visibility private
      # Supporting method overwriting to handle different device targets values
      def url_for(verb)
        url = URI.parse(ENV['IOS_DEVICE_ENDPOINT']|| "http://localhost:37265")
        path = url.path
        if path.end_with? "/"
          path = "#{path}#{verb}"
        else
          path = "#{path}/#{verb}"
        end
        url.path = path
        url
      end
    end
  end
end

