#!/usr/bin/env ruby

require_relative 'enigma'

# Uses defaults where rotor starting postions are A-A-A
puts "The First Super-Secret Text is:"
puts Enigma::Machine.new.convert('JZNUZQLGKALLRBETZOGQUPSBXGT')

# Find the rotor starting positions that allow the following to be decrypted
machine = Enigma::Machine.new
machine.rotors[2].set '?' # Left Rotor
machine.rotors[1].set '?' # Middle Rotor
machine.rotors[0].set '?' # Right Motor

puts "The Second Super-Secret Text is:"
puts machine.convert('SOHGLRJHIRYGIMZJRN')
