
# RedisStruct
### Syntactical Sugar for the Everyday Rubyist

* Built on OpenStruct
* Give persistant properties to variables!
* Made for Redis



##### OpenStruct Wonder

OpenStruct is a data type in ruby that gives variables infinite setter and getter methods. 

```
require 'ostruct'

icecream = OpenStruct.new()

icecream.flavor = 'strawberry'

icecream.flavor # => "strawberry"
```

##### RedisStruct makes this persistant

RedisStruct saves OpenStruct-like data structures in Redis:

```
require 'redis-struct'

$redis = Redis.new(:host => '0.0.0.0', :port => '6379')

doggy = RedisStruct.new($redis)

doggy.breed = 'poodle'

doggy.breed # => "poodle"

$redis.get "redis_struct:70346137426160:breed" # => "poodle"
```

##### Much simpler than vanilla redis

```
doggy.breed # => "poodle"
```

vs.


```
$redis.get('doggy-breed') # => "poodle"
```


##### Initialize with a hash

Just like with OpenStructs, you can make new RedisStructs with a hash:

```	
book_plan = { color: 'blue', pages: 365 }

book = RedisStruct.new(book_plan, $redis)

book.color # => 'blue'
```

##### Customizable Database Keys

The full parameters of RedisStruct.new() are as follows: 

```
RedisStruct.new(hash=nil, prefix = 'redis-struct', suffix = nil, database)
```

The hash, as you've seen, can be used to initialize an RedisStruct.

The prefix, by default 'redis_struct', is used in the first part of the database key. 

The suffix must be unique to each instance of RedisStruct. It's default value is an object id in RedisStruct's internal workings. 

To access the same RedisStruct from different scopes, specify the same prefix and suffix in RedisStruct.new()

Also note that to include a prefix or suffix without a starting hash you must use nil or an empty hash: `RedisStruct.new( nil, 'myprefix', 'mysuffix', $redis )`

## Installation

```
gem install redis-struct
```

```
require 'redis-struct'
```

## Contributing

- Fork the Project

- Make an addition; Fix a bug; Do your thing

- Add Tests

- Send me a pull request. I always appreciate help.

## Copywrite

MIT License. See LICENSE.TXT. Feel free to use and share!