# require 'simplecov'
# SimpleCov.start { add_filter '/spec/' }

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
           when String
             "'" + Regexp.escape(tvalue) + "'"
           when FalseClass, TrueClass
             tvalue ? 1 : 0
           when Array
             Regexp.escape('[' + tvalue.join(', ') + ']')
           else
             tvalue
    end

  %r{^\$Conf{#{fparam}}\s+=\s+#{fvalue};}
end
