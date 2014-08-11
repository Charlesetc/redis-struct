Gem::Specification.new do |s|
  s.name        = 'redis-struct'
  s.version     = '1.0.0'
  s.date        = '2014-08-10'
  s.summary     = "OpenStructs meet Redis"
  s.description = "OpenStructs meet Redis"
  s.authors     = ["Charles Chamberlain"]
  s.email       = 'charles@charlesetc.com'
  s.files       = ["lib/redis-struct.rb"]
	s.add_dependency "redis", "~> 3.1.0"
  s.homepage    =
    'https://github.com/Charlesetc/redis-struct#redis-struct'
  s.license       = 'MIT'
end