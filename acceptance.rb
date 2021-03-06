#!/usr/bin/env ruby

require_relative 'enigma'

puts "The Super-Secret Text is:"
puts Enigma::Machine.new.convert('JZNUZQLGKALLRBETZOGQUPSBXGT')

machine = Enigma::Machine.new
machine.rotors[2].set 'B' # Left Rotor
machine.rotors[1].set 'E' # Middle Rotor
machine.rotors[0].set 'D' # Right Motor

puts "The Super-Secret Text is:"
puts machine.convert('SOHGLRJHIRYGIMZJRN')

