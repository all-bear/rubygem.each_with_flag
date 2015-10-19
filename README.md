# Each with flags

Each with flags gem provides Enumerable methods"each_with_flag" and "each_with_index_with_flag" that expands standard methods "each" and "each_with_index" adding to yield block flags of first, has previous, surrounded, has next and has last element.

# Methods

## each_with_flag

Extend method each adding flags.

### Usage
```ruby
enumerable_obj.each_with_flag(flags) do |item, flag1, flag2| do
    # Your code here
end
```
### Available flags

- :first - is item first
- :is_first - same as :first
- :has_previous - is item has previous item in list
- :has_prev - same as :has_previous
- :surrounded - is item has previous and next item in list
- :is_surrounded - same as :surrounded
- :has_next - is item has next item in list
- :last - is item last in list
- :is_last - same as :last

### Example
```ruby
['foo', 'bar', 'baz'].each_with_flag(:first, :surrounded, :last) do |item, is_first, is_surrounded, is_last| do
    # is_first will be true only on first iteration
    # is_surrounded will be true only on second iteration
    # is_last will be true only on last iteration
end
```

## each_with_index_with_flag
The same as "each_with_flag" like "each" and "each_with_index"

## Additional method
Every flag has two additional metnods "each_with_{{flag_name}}" and "each_with_index_with_{{flag_name}}"

### Example
```ruby
['foo', 'bar', 'baz'].each_with_first_flag do |item, is_first,| do
    # is_first will be true only on first iteration
end

['foo', 'bar', 'baz'].each_with_index_with_first_flag do |item, index, is_first,| do
    # is_first will be true only on first iteration
end
```

## Version
0.1.0

License
----
MIT