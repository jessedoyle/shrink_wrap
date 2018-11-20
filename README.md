# Shrink::Wrap

## What is Shrink::Wrap?

Shrink::Wrap is a dead-simple framework to manipulate and map JSON data to Ruby object instances.

## Basic Example

Imagine a JSON structure such as:

```json
{
  "name": "Milky Way",
  "age": "13510000000",
  "solarSystems": [
    {
      "name": "Sol",
      "age": "4571000000",
      "planets": [
        {
          "name": "mercury"
        },
        {
          "name": "venus"
        },
        {
          "name": "earth"
        }
      ]
    }
  ]
}
```

With Shrink::Wrap, you'd be able to map the JSON data to Ruby instances as simply as:

```ruby
data = JSON.parse(File.read('galaxy.json'))
Galaxy.shrink_wrap(data) # => #<Galaxy:0x007fec71254828
 # @age=13510000000,
 # @name="Milky Way",
 # @solar_systems=
 #  [#<SolarSystem:0x007fec71254850
 #    @age=4571000000,
 #    @name="Sol",
 #    @planets=
 #     [#<Planet:0x007fec712555c0 @name="MERCURY">,
 #      #<Planet:0x007fec712553e0 @name="VENUS">,
 #      #<Planet:0x007fec71255200 @name="EARTH">>]>]>
```

## How Does it Work?

You must include the `Shrink::Wrap` module in your classes to gain access to the `shrink_wrap` method.

For the example above, the implementation would look like:

```ruby
require 'shrink/wrap'

class Planet
  include Shrink::Wrap

  transform(Shrink::Wrap::Transformer::Symbolize)

  translate(
    name: { from: :name }
  )

  coerce(
    name: ->(v) { v.upcase }
  )

  attr_accessor :name

  def initialize(opts = {})
    self.name = opts.fetch(:name)
  end
end

class SolarSystem
  include Shrink::Wrap

  transform(Shrink::Wrap::Transformer::Symbolize)

  translate(
    name: { from: :name },
    age: { from: :age },
    planets: { from: :planets }
  )

  coerce(
    age: ->(v) { v.to_i },
    planets: Array[Planet]
  )

  attr_accessor :name, :age, :planets

  def initialize(opts = {})
    self.name = opts.fetch(:name)
    self.age = opts.fetch(:age)
    self.planets = opts.fetch(:planets)
  end
end

class Galaxy
  include Shrink::Wrap

  transform(Shrink::Wrap::Transformer::Symbolize)

  translate(
    name: { from: :name },
    age: { from: :age },
    solar_systems: { from: :solarSystems }
  )

  coerce(
    age: ->(v) { v.to_i },
    solar_systems: Array[SolarSystem]
  )

  attr_accessor :name, :age, :solar_systems

  def initialize(opts = {})
    self.name = opts.fetch(:name)
    self.age = opts.fetch(:age)
    self.solar_systems = opts.fetch(:solar_systems)
  end
end
```

## Order of Operations

Shrink::Wrap operations are always deterministically performed in the following order:

1. `transform`
2. `translate`
3. `coerce`

Shrink::Wrap will call the `initialize` method with the data after all operations have been completed.

## Transform

The `transform` operation accepts a transformation class as well as an options hash as parameters.

The transformation class is any Ruby class that inherits from `Shrink::Wrap::Transformer::Base`.

The class must define a `transform(data = {})` method that returns the data after transformations are applied.

You can chain transformers together by calling `transform` multiple times in your class. Transformers are always executed sequentially.

You can create your own transformer as such:

```ruby
class FilterEmpty < Shrink::Wrap::Transformer::Base
  def transform(opts = {})
    data.each_with_object({}) do |(key, value), memo|
      memo[key] = value unless value.empty?
    end
  end
end
```

### Built In Transformers

Shrink::Wrap provides a few built-in transformer classes for use with common transformation patterns.

#### Shrink::Wrap::Transformer::Symbolize

In Ruby, it's very common to convert Hash keys to Symbol instances.

The Symbolize transformer works similar to ActiveSupport's [`deep_symbolize_keys`](https://api.rubyonrails.org/classes/Hash.html#method-i-deep_symbolize_keys) method, but it is also able to traverse nested data structures (`Array`, `Enumerable`) and symbolize the keys of any nested elements as well.

The Symbolize transformer accepts an optional `depth` parameter that defines that maximum depth for symbolization in nested data structures.

Example:

```ruby
class Example
  include Shrink::Wrap

  transform(Shrink::Wrap::Transformer::Symbolize, depth: 2)
  translate_all

  attr_accessor :data

  def initialize(data)
    self.data = data
  end
end

data = { 'root' => [{ 'nested' => 'test' }] }
instance = Example.shrink_wrap(data)
instance.data # => {:root=>[{:nested=>"test"}]}
```

#### Shrink::Wrap::Transformer::CollectionFromKey

Some data Hashes contain keys that contain relevant data for object instances.

The CollectionFromKey transformer accepts a Hash option that contains a key => attribute mapping.

The transformation then creates an Array of elements taken from the key argument and merges the key into each element in the collection.

Example:

```ruby
class Example
  include Shrink::Wrap

  transform(Shrink::Wrap::Transformer::CollectionFromKey, weekends: :day)
  translate_all

  attr_accessor :data

  def initialize(data)
    self.data = data
  end
end

data = {
  weekends: {
    saturday: {
      index: 6
    },
    sunday: {
      index: 0
    }
  }
}
instance = Example.shrink_wrap(data)
instance.data # => {:weekends=>[{:index=>6, :day=>:saturday}, {:index=>0, :day=>:sunday}]}
```

## Translate

The `translate` operation accepts a Hash that contains key/value pairs that map incoming data to attributes.

You can pass the following parameters for each attribute:

* `from` [**required**]: The input key that the attribute is mapped to.
* `allow_nil` [**optional**]: If `true`, the mapped value may be `nil`. When `false`, raises `KeyError` if the mapped value is `nil`.
* `default` [**optional**]: A `Proc` or `Lambda` that returns a particular value. This argument will be called if the value is `nil`.

### Passing Data During Initialization

By default, any attributes not specified in a `translate` call are not passed to the underlying object during initialization.

You can call `translate_all` if you wish to pass all of the data but don't wish to explicitly define the attributes in a corresponding `translate` call.

## Coerce

The `coerce` operation accepts a hash of attribute keys and coercion values.

Coercions must be one of the following types:

* `Class`: Tries calling `Class.shrink_wrap(data)`, `Class.coerce(data)`, then `Class.new(data)`, returning the first successful result.
* `Enumerable`: Coerces the value into the collection of type defined as the Enumerable elements. The first element of the enumerable must be a class name (eg. `Array[MyClass]`, `Hash[MyClass => MyClass]`).
* `Lambda/Proc`: Coerces the value by calling the `Proc` with the value as the only argument.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jessedoyle/shrink_wrap.

When making code changes please fork the main repository, create a feature branch and then create a pull request with your change. All code changes must contain adequate test coverage.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ShrinkWrap project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jessedoyle/shrink_wrap/blob/master/CODE_OF_CONDUCT.md).
