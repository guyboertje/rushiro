#$:.unshift File.expand_path("../../lib", __FILE__)

require 'ap'
#require 'cranky'
require 'rushiro'

def apr(what, header='')
  ap "== #{header} =="
  ap what
  ap "="*(header.size + 6)
end
