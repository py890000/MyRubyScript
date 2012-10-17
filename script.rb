#!/usr/bin/env ruby -w
# encoding: UTF-8
require 'rubygems'
require 'win32ole'
def getSheetByIndex(temp)
 a = temp.split('+@')
 a[1]
end

excel = WIN32OLE.new("excel.application")
workbook = excel.Workbooks.Open('E:\railsWork\myStudy\sql_result_4000.xls')
worksheet = workbook.Worksheets(1)
#worksheet.Select
filex = File.new('updateHitaosql3.sql', File::CREAT|File::TRUNC|File::RDWR, 0644)
for i in 2..3001 do
	if !worksheet.Range('d'+i.to_s).value
   next
  end
	
  filex.write("update hitao_order_coupons set mobile='")
  filex.write(getSheetByIndex(worksheet.Range('d'+i.to_s).value.to_s))
  filex.write("' WHERE source_id  =")
  filex.write(worksheet.Range('a'+i.to_s).value)  
  filex.write(" and source = 1 ;\n")
end
filex.close
excel.Quit()

