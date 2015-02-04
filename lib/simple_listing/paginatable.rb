require 'active_support/concern'

module SimpleListing
  module Paginatable
    extend ActiveSupport::Concern

    included do
      config page_param_key: :page, per_page_param_key: :per_page
    end

    def perform
      super
      apply_pagination if should_be_paginated?
      scope
    end

    def page
      params[config[:page_param_key]]
    end

    def per_page
      params[config[:per_page_param_key]]
    end

    def should_be_paginated?
      page && per_page
    end

    private

    def apply_pagination
      self.scope = scope.page(page).per(per_page)
    end
  end
end
