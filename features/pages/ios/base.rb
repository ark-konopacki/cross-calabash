require 'calabash-cucumber/ibase'

# <b>IOSBase basic methods</b>
class IosBase < Calabash::IBase

  # Defines page object elements
  def self.element element_name, &block
    define_method element_name.to_s, &block
  end
  class << self
    alias :value :element
    alias :action :element
    alias :trait :element
  end

  # Check if trait element(s) exists
  # @return {Boolean}
  def current_page?
    trait.kind_of?(Array) ? trait.all? { |element| element_exists(element) } : element_exists(trait)
  end

  # Waits for trait element(s) existing
  # @param {Hash} wait_opts
  # @return {Object} self
  def await(wait_opts={})
    wait_opts[:timeout] ||= 10
    unless wait_opts.has_key?(:await_animation) && !wait_opts[:await_animation]
      sleep(transition_duration)
    end
    if trait.kind_of?(Array)
      trait.each do |item|
        wait_opts[:timeout_message] = "Timeout waiting for element: \"#{item}\" on #{self.class.name}"
        wait_for_element_exists(item, wait_opts)

      end
    else
      wait_opts[:timeout_message] = "Timeout waiting for element: \"#{trait}\" on #{self.class.name}"
      wait_for_element_exists(trait, wait_opts)
    end
    self
  end

end