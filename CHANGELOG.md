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
