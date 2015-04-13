#!/usr/bin/env ruby

require_relative 'enigma'

puts "The Super-Secret Text is:"
puts Enigma::Machine.new.decrypt('JZNUZ QLGKA LLRBE TZOGQ UPSBX GT')
