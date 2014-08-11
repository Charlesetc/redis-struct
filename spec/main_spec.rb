require_relative '../lib/redis-struct.rb'
require 'rspec'

# require 'testrocket'


# Testing with RSpec

$redis = Redis.new :host => '0.0.0.0', :port => '6379'

puts
puts 'WARNING: Will clear Redis in'
3.times do |i|
	puts 3-i
	sleep 0.5
end
$redis.flushall
puts 'Redis cleared.'
puts



describe	'RedisStruct' do
	
	before(:each) do
		
		@house = RedisStruct.new({ height: 20, color: 'blue' }, $redis)
		
		@house.width = 24
		
	end
	
	it 'should function properly' do
		
		@house.color.should eql 'blue'
		@house.width.to_i.should eql 24
		@house.height.to_i.should eql 20
		@house.color.should_not eql 'yellow'
		@house.width.to_i.should_not eql 25
		
	end
	
	it 'should not use default functions' do
		@house.class = 'hello'
		@house.class.should eql 'hello'
	end
	
end

describe 'RedisHash' do
	
	before(:each) do
		@hash = RedisHash.new()
		@hash.config_database $redis
		@hash.config_prefix 'hash'
		@hash['hi'] = 'hey'
	end
	
	it 'should store values' do
		@hash['hi'].should eql 'hey'
	end
	
	it 'should have the right database prefix' do
		$redis.get("hash:#{@hash.object_id}:hi").should eql 'hey'
	end
	
	it 'should iterate properly' do
		@hash['hello'] = 'goodbye'
		
		keys = []
		
		@hash.each_key do |key|
			keys << key
		end
		
		keys.count.should eql 2
		
		values = []
		
		@hash.each_pair	do |key, value|
			values << value
		end
		
		values.count.should eql 2
		values.count.should_not eql 3
	end
	
end





# Testing with Test Rocket

# !-> { 'Testing RedisStruct functionality' }
#
# House = RedisStruct.new( {size: 24, color: 'blue'}, $redis )
#
# House.blue = 'color'
#
# +-> { House.size == 24.to_s }
# +-> { House.size != 23.to_s }
# +-> { House.color == 'blue' }
# +-> { House.color != 'red' }
# +-> { House.blue == 'color' }
#
# !-> { 'Testing RedisHash functionality' }
#
# hash = RedisHash.new(animal: 'sheep', cow: 'pig' )
# hash.config_database $redis
# hash.config_prefix 'testing'
# hash['color'] = 'blue'
# hash['kind'] = 'vector'
#
# +-> { hash['color'] == 'blue' }
# +-> { hash['color'] != 'purple' }
# +-> { hash['animal'] == 'sheep' }
# +-> { hash['cow'] != 'porcupine' }
#
# keys = []
#
# hash.each_key do |key|
# 	keys << key
# end
#
# +-> { keys.include? 'color' }
#
# keys = []
# values = []
#
# hash.each_pair do |key, value|
# 	keys << key
# 	values << value
# end
#
# +-> { keys == ['color', 'kind'] }
# +-> { values == ['blue', 'vector'] }





# MAKE DStruct

# MAKE RIRB