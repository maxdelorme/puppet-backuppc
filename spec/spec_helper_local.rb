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
  # <% if @backup_files_only.is_a?(Hash) -%>
  # $Conf{BackupFilesOnly} = {
  # <% @backup_files_only.keys.sort.each do |key| -%>
  # '<%= key %>'  => <% if @backup_files_only[key].is_a?(Array) %>['<%= @backup_files_only[key].join("', '") %>']<% else %><%= @backup_files_only[key] %><% end %>,
  # <% end -%>
  # };
  # <% elsif @backup_files_only.is_a?(Array) -%>
  # $Conf{BackupFilesOnly} = ['<%= @backup_files_only.join("', '") %>'];
  # <% else -%>
  # $Conf{BackupFilesOnly} = '<%= @backup_files_only %>';
  # <% end -%>

  fvalue = case tvalue
           when String
             "'" + Regexp.escape(tvalue) + "'"
           when FalseClass, TrueClass
             tvalue ? 1 : 0
           when Array
             #Regexp.escape('[' + tvalue.join(', ') + ']')
             Regexp.escape('[' + tvalue.map{|item| %Q{#{item}}}.join(', ') + ']')
           else
             tvalue
           end

  fvalue
end

def config_content(tparam, tvalue)
  fparam = extractkey(tparam)

  fvalue = extractvalue(tvalue)

  %r{^\$Conf{#{fparam}}\s+=\s+#{fvalue};}
end
