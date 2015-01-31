module SimpleListing
  module Sortable
    extend ActiveSupport::Concern

    SORT_VALUE_KEY = :sort_by
    SORT_DIRECTION_KEY = :sort_dir

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

    def perform
      super
      apply_sorting
      scope
    end

    def sort_value
      @sort_value ||= params[SORT_VALUE_KEY].tap do |value|
        guard("incorrect sorting value '#{value}'") { sortable_by?(value) }
      end
    end

    def sort_direction
      @sort_direction ||= begin
        direction = params[SORT_DIRECTION_KEY]
        guard("incorrect sorting direction '#{direction}'") { direction.in? SORT_DIRECTIONS }
        direction.to_sym
      end
    end

    def inverted_sort_direction
      sort_direction == :asc ? :desc : :asc
    end

    private

    def apply_sorting
      self.scope = if handler = self.class.sorting_handlers[sort_value]
                     handler.call(scope, sort_direction, self)
                   else
                     scope.order(sort_value => sort_direction)
                   end
    end

    def sortable_by?(value)
      self.class.sortable_keys.include? value
    end
  end
end
