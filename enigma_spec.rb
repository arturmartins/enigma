require_relative 'enigma'

describe Enigma do

  let(:rotor_iii) { Enigma::Rotor.new(Enigma::ROTOR_III_MAP, Enigma::ROTOR_III_NOTCH) }
  let(:rotor_ii) { Enigma::Rotor.new(Enigma::ROTOR_II_MAP, Enigma::ROTOR_II_NOTCH) }
  let(:rotor_i) { Enigma::Rotor.new(Enigma::ROTOR_I_MAP, Enigma::ROTOR_I_NOTCH) }
  let(:reflector_b) { Enigma::Reflector.new(Enigma::REFLECTOR_B_MAP) }
  let(:machine) { Enigma::Machine.new }

  describe Enigma::Rotor do

    it 'should start with "A" as the window char' do
      expect(rotor_iii.window_char).to eql 'A'
    end

    it 'should rotate 1 step so that "B" is the window character' do
      rotor_iii.rotate!
      expect(rotor_iii.window_char).to eql 'B'
    end

    it 'should rotate back to "A" when position is "Z"' do
      rotor_iii.set('Z')
      rotor_iii.rotate!
      expect(rotor_iii.window_char).to eql 'A'
    end

    it 'rotor III should forward map "A" to "B"' do
      expect(rotor_iii.forward('A')).to eql 'B'
    end

    it 'rotor III rotated 1 step should forward map "A" to "D"' do
      rotor_iii.rotate!
      expect(rotor_iii.forward('A')).to eql 'D'
    end

    it 'rotor III rotated 1 step should reverse map "D" to "A"' do
      rotor_iii.rotate!
      expect(rotor_iii.reverse('D')).to eql 'A'
    end

    it 'rotor III set to "Z" and rotated 1 step should forward map "A" to "O"' do
      rotor_iii.set('Z')
      expect(rotor_iii.forward('A')).to eql 'O'
    end

    it 'rotor III should reverse map "B" to "A"' do
      expect(rotor_iii.reverse('B')).to eql 'A'
    end

    it 'rotors III and II at defaults should forward map "A" to "J"' do
      char = rotor_iii.forward('A')
      expect(rotor_ii.forward(char)).to eql 'J'
    end

    it 'rotors III and II at defaults should reverse map "J" to "A"' do
      char = rotor_ii.reverse('J')
      expect(rotor_iii.reverse(char)).to eql 'A'
    end

    it 'rotors III and II with III set to "B" should forward map "A" to "D"' do
      rotor_iii.set('B')
      rotor_ii.right = rotor_iii
      char = rotor_iii.forward('A')
      expect(rotor_ii.forward(char)).to eql 'D'
    end

    it 'rotors III and II with III set to "B" should reverse map "D" to "A"' do
      rotor_iii.set('B')
      rotor_ii.right = rotor_iii
      char = rotor_ii.reverse('D')
      expect(rotor_iii.reverse(char)).to eql 'A'
    end

    it 'rotors III and II with III set to "B" & "C" should forward map "A" to "S"' do
      rotor_iii.set('B')
      rotor_ii.set('C')
      rotor_ii.right = rotor_iii
      char = rotor_iii.forward('A')
      expect(rotor_ii.forward(char)).to eql 'S'
    end

    it 'rotors III and II with III set to "B" & "C" should reverse map "S" to "A"' do
      rotor_iii.set('B')
      rotor_ii.set('C')
      rotor_ii.right = rotor_iii
      char = rotor_ii.reverse('S')
      expect(rotor_iii.reverse(char)).to eql 'A'
    end

    it 'rotor III should not indicate turnover when "A" in in the window' do
      rotor_iii.set('A')
      expect(rotor_iii.turnover?).to eql false
    end

    it 'rotor III should indicate turnover when "W" in in the window' do
      rotor_iii.set('V')
      expect(rotor_iii.turnover?).to eql true
    end

  end

  describe Enigma::Reflector do

    it 'reflector B should map "A" to "Y"' do
      expect(reflector_b.reflect('A')).to eql 'Y'
    end

    it 'reflector B should map "Y" to "A"' do
      expect(reflector_b.reflect('Y')).to eql 'A'
    end

    it 'reflector B with Rotor III at defaults should map "A" to "I"' do
      reflector_b.right = rotor_iii
      char = rotor_iii.forward('A')
      char = reflector_b.reflect(char)
      expect(rotor_iii.reverse(char)).to eql 'I'
    end

    it 'reflector B with Rotor III at defaults should map "I" to "A"' do
      reflector_b.right = rotor_iii
      char = rotor_iii.forward('I')
      char = reflector_b.reflect(char)
      expect(rotor_iii.reverse(char)).to eql 'A'
    end

    it 'reflector B with Rotor III at "B" should map "A" to "K"' do
      rotor_iii.set('B')
      reflector_b.right = rotor_iii
      char = rotor_iii.forward('A')
      char = reflector_b.reflect(char)
      expect(rotor_iii.reverse(char)).to eql 'K'
    end

  end

  describe 'breadboard' do

    it 'full set up converts should convert "J" to "S"' do
      rotor_i.set('A')
      rotor_i.right = rotor_ii

      rotor_ii.set('A')
      rotor_ii.left = rotor_i
      rotor_ii.right = rotor_iii

      rotor_iii.set('B')
      rotor_iii.left = rotor_ii

      reflector_b.right = rotor_i

      char = rotor_iii.forward('J')
      char = rotor_ii.forward(char)
      char = rotor_i.forward(char)

      char = reflector_b.reflect(char)

      char = rotor_i.reverse(char)
      char = rotor_ii.reverse(char)
      char = rotor_iii.reverse(char)

      expect(char).to eql 'S'
    end

  end

  describe Enigma::Machine do

    it 'should convert "J" to "S" on default settings' do
      expect(machine.convert('J')).to eql 'S'
    end

    it 'setup with rotors "B-E-D" should rotate to "C-F-E"' do
      machine.rotors[2].set 'B'
      machine.rotors[1].set 'E'
      machine.rotors[0].set 'D'
      machine.rotate!
      expect(machine.rotors[2].window_char).to eql 'C'
      expect(machine.rotors[1].window_char).to eql 'F'
      expect(machine.rotors[0].window_char).to eql 'E'
    end

  end

end

