# encoding: utf-8
require 'rubygems'
require "mysql"
require "activesupport"
class String

  def uppercase
    str = to_s
    str[0,1].upcase + str[1..-1]
  end

  def lowercase
    str = to_s
    str[0,1].downcase + str[1..-1]
  end

end

class ColumnInfo
  def initialize(field, type, default, comment)
    @field, @type, @default, @comment = field, type, default, comment
  end

  attr_accessor :field, :type, :default, :comment

  def to_s
    @field.to_s + @type.to_s + @default.to_s + @comment.to_s
  end
end

def camelize temp
  ActiveSupport::Inflector::Inflections.camelize( temp )
end


client = Mysql2::Client.new(:host => "10.232.31.88", :database => "shopware", :username => "hitao", :password => "hitao", :encoding => "utf8")
client.query('USE information_schema')
table_name = "ht_refund_form"
res = client.query("SELECT * FROM COLUMNS WHERE table_name = '"+ table_name +"' ", {:encoding => "utf8"})

columns = Array.new

res.each do |i|
  columns << ColumnInfo.new(i["COLUMN_NAME"], i["DATA_TYPE"], i["COLUMN_DEFAULT"], i["COLUMN_COMMENT"])
end
DATA_TYPE = {"bigint" => "Long",
             "varchar" => "String",
             "int" => "Integer",
             "tinyint" => "Integer",
             "datetime" => "java.util.Date"
}


filex = File.new(camelize(table_name) + '.java', File::CREAT|File::TRUNC|File::RDWR, 0644)
filex.write("public class " +camelize(table_name)+"DO  {")
columns.each do |i|
  filex.write( "// "+ i.comment.to_s  + "\n" )
  filex.write("private ")
  filex.write(DATA_TYPE[i.type] + "   "+ camelize(i.field).lowercase  + " \n")
end

columns.each do |i|
  filex.write("public void set"+camelize(i.field)+"( "+DATA_TYPE[i.type] +"   " +camelize(i.field).lowercase  + " ) " )
  temp  = camelize(i.field).lowercase
  filex.write("{  this."+ temp  +"="  + temp + ";     } \n " )

  filex.write("public "+DATA_TYPE[i.type]+"    get"+camelize(i.field)+ "( ){" )
  filex.write(" return this."+temp+";}\n")
end
filex.write("}")
filex.close








