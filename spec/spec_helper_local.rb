require 'pp'
require 'simplecov'

if ENV['SIMPLECOV']
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
  ]
  SimpleCov.start { add_filter '/spec/' }
elsif ENV['TRAVIS'] && RUBY_VERSION.to_f >= 1.9
  require 'coveralls'
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ]
  Coveralls.wear! { add_filter '/spec/' }
end

# method to convert between puppet and backuppc names, and to convert values
def config_content(tparam, tvalue)
  fparam = tparam.split('_').map { |e|
    case e
    when 'backuppc'
      'BackupPC'
    when 'email'
      'EMail'
    when 'url', 'mmdd'
      e.upcase
    else
      e.capitalize
    end
  }.join

  fvalue = case tvalue
           when FalseClass, TrueClass
             tvalue ? 1 : 0
           else
             Regexp.escape(PP.pp(tvalue, '').chomp.tr('"', "'"))
           end

  %r{^\$Conf{#{fparam}}\s+=\s+#{fvalue};}m
end
