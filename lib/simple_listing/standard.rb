require "simple_listing/base"
require "simple_listing/filterable"
require "simple_listing/paginatable"
require "simple_listing/sortable"

module SimpleListing
  class Standard < Base
    include Filterable
    include Sortable
  end
end
