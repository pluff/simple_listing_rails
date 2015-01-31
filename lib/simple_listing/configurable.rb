module SimpleListing
  module Configurable
    extend ActiveSupport::Concern

    module ClassMethods
      def config(config_hash = nil)
        self.configuration = configuration.merge(config_hash) if config_hash
        configuration
      end
    end

    included do
      class_attribute :configuration
      self.configuration = {}
    end
  end
end
