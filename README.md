
# ROStruct
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

##### ROStruct makes this persistant

ROStruct (RedisOpenStruct) saves OpenStruct-like data structures in Redis:

```
require 'rostruct'

$redis = Redis.new(:host => '0.0.0.0', :port => '6379')

doggy = ROStruct.new($redis)

doggy.breed = 'poodle'

doggy.breed # => "poodle"

$redis.get "rostruct:70346137426160:breed" # => "poodle"

```

##### Much simpler than vanilla redis

```
doggy.breed
```

vs.


```
$redis.get('doggy-breed')
```


##### Initialize with a hash

Just like with OpenStructs, you can make new ROStructs with a hash:

```	
book_plan = { color: 'blue', pages: 365 }

book = ROStruct.new(book_plan, $redis)

book.color # => 'blue'

```

##### Customizable Database Keys

The full parameters of ROStruct.new() are as follows: 

```
ROStruct.new(hash=nil, prefix = 'rostruct', suffix = nil, database)
```

The hash, as you've seen, can be used to initialize an ROStruct.

The prefix, by default 'rostruct', is used in the first part of the database key. 

The suffix must be unique to each instance of ROStruct. It's default value is an object id in ROStruct's internal workings. 

To access the same ROStruct from different scopes, specify the same prefix and suffix in ROStruct.new()

Also note that to include a prefix or suffix without a starting hash you must use nil or an empty hash: `ROStruct.new( nil, 'myprefix', 'mysuffix', $redis )`

## Installation

```
gem install rostruct
```

```
require 'rostruct'
```

## Contributing

- Fork the Project

- Make an addition; Fix a bug; Do your thing

- Add Tests

- Send me a pull request. I always appreciate help.

## Copywrite

MIT License. See LICENSE.TXT. Feel free to use and share!