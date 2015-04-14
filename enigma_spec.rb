require_relative 'enigma'

describe Enigma do

  describe Enigma::Rotor do

    let(:rotor_iii) { Enigma::Rotor.new(Enigma::ROTOR_III_MAP) }
    let(:rotor_ii)  { Enigma::Rotor.new(Enigma::ROTOR_II_MAP) }

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
      char = rotor_iii.forward('A')
      expect(rotor_ii.forward(char, rotor_iii.offset)).to eql 'D'
    end

    it 'rotors III and II with III set to "B" should reverse map "D" to "A"' do
      rotor_iii.set('B')
      char = rotor_ii.reverse('D',rotor_iii.offset)
      expect(rotor_iii.reverse(char)).to eql 'A'
    end
  end

end

