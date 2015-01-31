module SimpleListing
  module Sortable
    extend ActiveSupport::Concern

    SORT_DIRECTIONS = %w{asc desc}.freeze

    module ClassMethods
      attr_reader :sortable_keys
      attr_reader :sorting_handlers

      def sortable_by(*keys)
        @sortable_keys ||= []
        @sortable_keys += keys.map(&:to_s)
        @sortable_keys.uniq!
      end

      def sort_by(key, handler_proc)
        sortable_by key
        @sorting_handlers ||= {}.with_indifferent_access
        @sorting_handlers[key] = handler_proc
      end
    end

    included do
      delegate :sorting_handlers, :sortable_keys, to: :class

      config sort_by_param_key: :sort_by, sort_direction_param_key: :sort_dir
    end

    def perform
      super
      apply_sorting if should_be_sorted?
      scope
    end

    def sort_value
      @sort_value ||= params[config[:sort_by_param_key]].tap do |value|
        guard("incorrect sorting value '#{value}'") { sortable_by?(value) }
      end
    end

    def sort_direction
      @sort_direction ||= begin
        direction = params[config[:sort_direction_param_key]]
        guard("incorrect sorting direction '#{direction}'") { direction.in? SORT_DIRECTIONS }
        direction.to_sym
      end
    end

    def inverted_sort_direction
      sort_direction == :asc ? :desc : :asc
    end

    def should_be_sorted?
      params[config[:sort_by_param_key]] && params[config[:sort_direction_param_key]]
    end

    private

    def apply_sorting
      self.scope = if handler = sorting_handlers[sort_value]
                     handler.call(scope, sort_direction, self)
                   else
                     scope.order(sort_value => sort_direction)
                   end
    end

    def sortable_by?(value)
      sortable_keys.include? value
    end
  end
end
