#!/usr/bin/env ruby -w
# encoding: UTF-8
require 'rubygems'
require "mysql2"
require 'erb'
require 'active_support/all'


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


class TableInfo
  #packageName 包名
  #tableCode 表的英文名称
  #tableName 表的中文名称
  #clumns 是 2 维数组，其中每个元素为 [columnCode, columnName, columnType, isPK] 
  attr_accessor :packageName,:tableCode, :tableName, :columns

  def initialize(packageName, tableCode, tableName, columns)
    @packageName = packageName
    @tableCode = tableCode
    @tableName = tableName
    @columns = columns
  end

  def get_binding
     return binding()
  end
end

class ColumnInfo
  def initialize(field, type, default, comment)
    @field, @type, @default, @comment = field, type, default, comment.force_encoding("GB2312")
  end

  attr_accessor :field, :type, :default, :comment

  
  def get_binding
     return binding()
  end
end

#生成代码主要类
class  CreateCode

  def self.getxColums(table_name,table_chinise_name)
      client = Mysql2::Client.new(:host => "10.232.31.148", :database => "shopware", :username => "hitao", :password => "hitao", :encoding => "utf8")
      client.query('USE information_schema') 
      res = client.query("SELECT * FROM COLUMNS WHERE table_name = '"+ table_name +"' ", {:encoding => "utf8"})
      columns = Array.new
        res.each do |i|
          #puts i["COLUMN_COMMENT"].encoding 
          columns << ColumnInfo.new(i["COLUMN_NAME"], i["DATA_TYPE"], i["COLUMN_DEFAULT"], i["COLUMN_COMMENT"])
        end
      bean =  TableInfo.new("eorder.eticket",table_name,table_chinise_name,columns)
      file_name = bean.tableCode.camelize

     #  "DAO.java.erb","DAOImpl.java.erb","Manager.java.erb",
       # "ManagerImpl.java.erb","AO.java.erb","AOImpl.java.erb","Action.java.erb",
      files = ["List.vm.erb","Info.vm.erb","Edit.vm.erb"]

      files.each{ |template|    
             templatefile =ERB.new(File.read(template))
            file = "#{file_name}"+template
            f = File.new(file,  File::CREAT|File::TRUNC|File::RDWR, 0644)
            f.puts templatefile.result(bean.get_binding)
            f.close
        }
  
  end
end

CreateCode.getxColums("ht_return_form","退款单".force_encoding("GB2312"))


















#putstemplate.result(sbean.get_binding)

