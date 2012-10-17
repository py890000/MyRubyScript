#def colum_to_name temp
#  ch = String.new()
#   temp.scan(/[a-zA-Z0-9]+/){|f| ch = ch + f.capitalize }
#  temp = ch
#  return temp
#end


# -*- coding: UTF-8 -*-
require 'erb'

template = ERB.new <<EOF
<%#-*- coding: Big5 -*-%>
  \_\_ENCODING\_\_ is <%= \_\_ENCODING\_\_ %>.
EOF
puts template.result


.force_encoding("GB2312")
 
 	