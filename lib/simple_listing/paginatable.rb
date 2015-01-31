module SimpleListing
  module Paginatable

    PAGE_KEY = :page
    PER_PAGE_KEY = :per_page

    def perform
      super
      apply_pagination
      scope
    end

    def page
      params[PAGE_KEY]
    end

    def per_page
      params[PER_PAGE_KEY]
    end

    private

    def apply_pagination
      self.scope = scope.page(page).per(per_page)
    end
  end
end
