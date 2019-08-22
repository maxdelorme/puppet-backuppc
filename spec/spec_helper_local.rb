if ENV["SIMPLECOV"]
  require "simplecov"
  SimpleCov.start { add_filter "/spec/" }
elsif ENV["TRAVIS"] && RUBY_VERSION.to_f >= 1.9
  require "coveralls"
  Coveralls.wear! { add_filter "/spec/" }
end
