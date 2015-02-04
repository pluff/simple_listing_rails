require 'active_support/concern'

module SimpleListing
  module Filterable
    extend ActiveSupport::Concern

    module ClassMethods
      attr_reader :filterable_keys
      attr_reader :filtering_handlers

      def filterable_by(*keys)
        @filterable_keys ||= []
        @filterable_keys += keys.map(&:to_s)
        @filterable_keys.uniq!
      end

      def filter_by(key, handler_proc)
        filterable_by key
        @filtering_handlers ||= {}.with_indifferent_access
        @filtering_handlers[key] = handler_proc
      end
    end

    included do
      delegate :filtering_handlers, :filterable_keys, to: :class

      config filter_params_key: :filters
    end

    def perform
      super
      apply_filters if should_be_filtered?
      scope
    end

    def filter_params
      params[config[:filter_params_key]]
    end

    def should_be_filtered?
      filter_params && filter_params.respond_to?(:each)
    end

    private

    def apply_filters
      filter_params.each do |key, value|
        guard("incorrect filter key '#{key}'") { filterable_by?(key) }
        self.scope = if handler = filtering_handlers[key]
                       handler.call(scope, value, self)
                     else
                       scope.where(key => value)
                     end
      end
    end

    def filterable_by?(key)
      key.to_s.in? filterable_keys
    end
  end
end
