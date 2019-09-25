require 'pp'
# require 'simplecov'
# SimpleCov.start { add_filter '/spec/' }

# method to convert between puppet and backuppc names, and to convert values
def extractkey(tparam)
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
  fparam
end

def extractvalue(tvalue)
  fvalue = case tvalue
           when FalseClass, TrueClass
             tvalue ? 1 : 0
           else
             Regexp.escape(PP.pp(tvalue, '').chomp)
           end

  fvalue
end

def config_content(tparam, tvalue)
  fparam = extractkey(tparam)

  fvalue = extractvalue(tvalue)

  %r{^\$Conf{#{fparam}}\s+=\s+#{fvalue};}m
end
