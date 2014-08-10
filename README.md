
# RStruct
### Syntactical Sugar for the Everyday Rubyist

* Built on OpenStruct
* Give persistant properties to variables!
* Made for Redis

OpenStruct is a data type in ruby that gives variables infinite setter and getter methods. 

```
require 'ostruct'

icecream = OpenStruct.new()

icecream.flavor = 'strawberry'

icecream.flavor # => "strawberry"

```

##### RStruct makes this persistant

Imagine saving an object like this in Redis. That's an RStruct!

```
require 'rstruct'

$redis = Redis.new(:host => '0.0.0.0', :port => '6379')

doggy = RStruct.new($redis)

doggy.breed = 'poodle'

doggy.breed # => "poodle"

```

##### Much simpler than generic redis

Compare `redis.get('doggy-breed')` to `doggy.breed`


##### Initialize with a hash

Just like with OpenStructs, you can make new RStructs with a hash:

```	
book_plan = { color: 'blue', pages: 365 }

book = RStruct.new(book_plan, $redis)

book.color # => 'blue'

```

##### Customizable Database Keys

The full parameters of RStruct.new() are as follows: 

```
RStruct.new(hash=nil, prefix = 'rstruct', suffix = nil, database)
```

The hash, as you've seen, can be used to initialize an RStruct.

The prefix, by default 'rstruct', is used in the first part of the database key. 

The suffix must be unique to each instance of RStruct. It's default value is an object id in RStruct's internal workings. 

To access the same RStruct from different scopes, specify the same prefix and suffix in RStruct.new()
