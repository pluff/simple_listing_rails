# SimpleListingRails

This gem provides easy listing objects for your ActiveRecord relations.

## Why

Usually application listings have are sortable, filterable and can be paginated.
I need an easy straightforward way to write flexible filters and sortings for my app, so I created this gem.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_listing_rails'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install simple_listing_rails

## Usage

### Minimal required code

First of all you need to define a listing class. E.g.

```ruby
class UserListing < SimpleListing::Standard
end
```

and then use it in your controller with "perform" function:

```ruby
def index
  @users = UserListing(User.all, params).perform
end
```

Now you can add some filters or sortings declaration to your class.

### Filtering

#### Simple "equal" filters

You can add strict match filter to your listing class with only one line:

```ruby
class UserListing < SimpleListing::Standard
  filterable_by :first_name, :last_name, :email
end
```

`filterable_by` will perform "=" comparision with corresponding value in DB.

#### Custom filters

If you need your own custom filter with custom logic you can use `filter_by` function:

```ruby
class UserListing < SimpleListing::Standard
  filter_by :email, lambda { |scope, value, listing|
    scope.where("email LIKE ?", "%#{value}")
  }
end
```

`filter_by` accepts filtering key and lambda-function with your own custom logic. As you see lambda accepts 3 arguments and MUST return a scope.

Keep in mind that "value" parameter can be a hash, so you can create complex filters e.g.:

```ruby
class UserListing < SimpleListing::Standard
  filter_by :age, lambda { |scope, value, listing|
    scope.where("age > :min AND age < :max", value)
  }
end
```

#### Filters configuration

By default simple_listing pulls filters data from "params[:filters]".
If you need to change params key you can do it so by calling "config" function

```ruby
class UserListing < SimpleListing::Standard
  config filter_params_key: :my_filters
end
```

In case you need completely different behavior you can override "filter_params" function in your listing class.

See more details in source code.

### Sorting

#### Simple sorting by DB field

You can add sortings to your listing class with only one line:

```ruby
class UserListing < SimpleListing::Standard
  sortable_by :first_name, :last_name, :email
end
```

#### Custom sorting

If you need your own custom sorting with custom logic you can use `sort_by` function:

```ruby
class UserListing < SimpleListing::Standard
  sort_by :email, lambda { |scope, direction, listing|
    scope.order("CONCAT(first_name, last_name) #{direction}")
  }
end
```

`sort_by` accepts sorting key and lambda-function with your own custom logic. As you see lambda accepts 3 arguments and MUST return a scope.

#### Sorters configuration

By default simple_listing pulls sorting data from "params[:sort_by]" and "params[:sort_dir]".
If you need to change params keys you can do it so by calling "config" function

```ruby
class UserListing < SimpleListing::Standard
  config sort_by_param_key: :sind, sort_direction_param_key: :sord
end
```

See more details in source code.

### Customizing your listings

In rare case when you want to remove sorting or filtering ability from your listing
you can always inherit from "SimpleListing::Base" class and include only modules you need.

## Contributing

1. Fork it ( https://github.com/pluff/simple_listing_rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request



