require './lib/redis-struct.rb'

$redis = Redis.new :host => '0.0.0.0', :port => '6379'

puts

Signal.trap("INT") { puts; break }


# Here's the console for RStruct. 
# Simple, but good for fiddling.


# Used more in development than in production


def get_binding
	return binding
end

b = get_binding


loop do
	
	begin
		
		
		print ' >> '
		
		command = gets.chomp
				
		command = command.gsub /LAST/, @last if @last
		
		@last = nil
		
		case command
		when  /^(quit)|(exit)|(q)$/
			break
		when /^clear$/
			puts `clear`
		else
			@last = eval command, b
			puts @last
		end
		
	rescue Exception => e
		
		puts e
		
	end
	
end

puts