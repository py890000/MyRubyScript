# encoding: utf-8

require 'active_support/inflector/inflections'
class String
  include ActiveSupport
end

p "ht_f".c camelize