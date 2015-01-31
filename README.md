# SimpleListingRails

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'simple_listing_rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_listing_rails

## Usage

TODO: Write usage instructions here

Consider we have following model:

```ruby
class User < ActiveRecord::Base
  #attributes: first_name, last_name, age, gender, email
end
```

Listing class for this model might look like this:

```ruby
class UsersListing < SimpleListing::Standard
  sortable_by :age, :email #Adds sorting by two regular attributes

  #Adds sorting by specific key "full_name".
  sort_by :full_name, lambda { |scope, direction, listing|
                     scope.order("concat(first_name, last_name) #{direction}")
                   }

  filterable_by :gender #Adds strict match filtering by one attribute

  #Adds filtering by email as custom behavior
  filter_by :email, lambda { |scope, value, listing|
                       scope.where("email LIKE ?", "%#{value}%")
                     }

  #Adds filtering by salary as custom behavior with complex value. Consider "value" is {min: 10, max: 30} hash
  filter_by :age, lambda { |scope, value, listing|
                      scope.where("age > :min AND age < :max", value)
                    }
end
```

You can use listing class above in your controller:

```ruby
class UsersController < ApplicationController
  def index
    @users = UsersListing.new(User.all, params).perform
  end
end
```

After that you can send request with following params params:

```ruby
{
  filters: {
    age: {min: 10, max: 30},
    email: 'alice',
    gender: 'male'
    }
  sort_by: 'full_name',
  sort_dir: 'desc',
  page: 3,
  per_page: 10
}
```

and check out the results! ;)

## Contributing

1. Fork it ( https://github.com/pluff/simple_listing_rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
