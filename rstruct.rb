
require 'ostruct'
require 'redis'

class RedisHash < Hash
	
	@fixed = false
	
	def config_database(database)
		@database = database
	end
	
	def config_prefix(prefix)
		@prefix = prefix
	end
	
	def config_suffix(suffix)
		@suffix = suffix
	end
	
	def config_rstuct(rstruct)
		@rstruct = rstruct
	end
	
	def config_hash(hash)
		@hash = hash
	end
	
	def []=(key,value)
		@database.set prefix(key), value
	end
	
	def [](key)
		@database.get prefix(key)
	end
	
	def each_key(&block)
		keys = @database.keys prefix("*")
		keys.each do |key|
			yield unprefix(key)
		end
	end
	
	def each_pair # (&block) ## I don't think this works.
		each_key do |key|
			value = self[key]
			yield unprefix(key), value
		end
	end
	
	def dup 
		self
	end
	
	def to_h
		hash = {}
		each_key do |key|
			hash[key] = self[key]
		end
		hash
	end
	
	def prefix(key)
		"#{@prefix}:#{get_suffix}:#{key}"
	end
	
	def get_suffix
		@suffix || self.object_id
	end
	
	def unprefix(key)
		key.sub /^#{@prefix}:#{get_suffix}:/, ''
	end
	
	def prefix_with_id(key)
		"#{@prefix}:#{self.object_id}:#{key}"
	end
	
	def add_hash
		@hash.each_pair do |key,value|
			self[key] = value
		end
	end
	
	def delete(key)
		@database.del prefix(key)
	end
	#
	# private
	#
	# # An internal method that uses the name of @rstruct when possible,
	# # otherwise the RedisHash's object id.
	# 	def fix
	# 		begin
	# 			unless @fixed
	# 				@fixed = true
	# 				add_hash
	# 			end
	# 			result = @rstruct.very_old_name
	# 			# puts 'not rescued'
	# 		rescue Exception => e
	# 			p e
	# 			# puts 'rescued'
	# 			result = self.object_id
	# 		end
	# 		result
	# 	end
		
	
end


class RStruct < OpenStruct
	
	
	# This resets unnecessary methods for users'
	# convenience.
	
	# Uncomment these to access old methods
	
	# alias :very_old_class :class
	# alias :very_old_display :display
	# alias :very_old_clone :clone
	# alias :very_old_trust :trust
	# alias :very_old_method :method
	# alias :very_old_taint :taint
	
	undef :taint
	undef :method
	undef :trust
	undef :clone
	undef :display
	undef :class

	
	
	# An RStruct wraps the OpenStruct class, which uses method_missing
	# to store values in a hash. Instead, RStruct stores these values
	# in Redis, providing a pleasant way of interfacing with $redis.
	#
	# #When $redis = Redis.new :host => '0.0.0.0', :port => '6379'
	# example = RStruct.new($redis)
	# 
	# example.color = 'blue'
	# 
	# example.color  # => 'blue'
	#
	# The hash will load any data you want into the RStruct, without
	# having to iterate over it. And the prefix is what's used to 
	# store in $redis. Good luck!
	 
  def initialize(hash=nil, prefix = 'rstruct', suffix = nil, database)
    @table = RedisHash.new
		@table.config_database database
		@table.config_prefix prefix
		
		if suffix
			@table.config_suffix suffix
		end
		
		# Enables the user to load a hash into the database
		# Hash will be compiled later - once the RStruct's name is known
		@table.config_hash hash
		@table.add_hash if hash
		
  end
	
	def get_redis_hash_object_id
		@table.object_id
	end
	
	def to_str
		to_h.to_s
	end
	
	# Rewriting so RStruct#to_h doesn't call RedisHash#dup
	def to_h
		@table.to_h
	end
	
end




# Examples

# It's generally better to use an RStruct than make
# a RedisHash directly. RedisHashes are more adapters
# than anything else.
#
#
#
# $redis = Redis.new :host => '0.0.0.0', :port => '6379'
#
# icecream = RedisHash.new
# icecream.config_database $redis
# icecream.config_prefix 'hello'
# icecream['color'] = 'blue'
#
# p icecream['color']
# puts
# puts '-------------'
# puts
# 
#
# 
# Snowcone = RStruct.new({name: 'blue'}, $redis)
#
# Snowcone.class = 'hi'
#
# p Snowcone.class
# p Snowcone.name
#
# Snowcone.kind = 'sheep'
# Snowcone.blue = 'animal'
#
# p Snowcone.kind
# p Snowcone.blue
#
# p Snowcone.color
#
#
# puts Snowcone.name