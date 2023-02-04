# 1.0.2 - Feb 3, 2023

* Fix an issue with the `shrink_wrap` require statement. [#8], Thanks @mvandenbeuken!

# 1.0.1 - June 1, 2021

* Translation properties that define a `default` option now correctly call resolve the default value when the input value is explicitly `nil`. See [#7](https://github.com/jessedoyle/shrink_wrap/pull/7).

# 1.0.0 - Oct 1, 2020

* Explicity require `stringio` from the standard library as it is used for some error messages.

# 0.2.0 - Apr 17, 2020

* **breaking change**: Modify the `CollectionFromKey` transformer to map non-hash values into a hash with a `value` property.

i.e.
```ruby
input = { names: { john: 'foo', jane: 'bar' } }
transformer.transform(input) #=>  { names: [{ name: :john, value: 'foo' }, { name: :jane, value: 'bar' }] }
```

# 0.1.0 - Dec. 2, 2018

* Initial release! :sparkles:
