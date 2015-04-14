require_relative 'enigma'

describe Enigma do

  describe Enigma::Rotor do

    let(:rotor_iii) { Enigma::Rotor.new(Enigma::ROTOR_III_MAP, Enigma::ROTOR_III_NOTCH) }
    let(:rotor_ii)  { Enigma::Rotor.new(Enigma::ROTOR_II_MAP, Enigma::ROTOR_II_NOTCH) }

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
      rotor_iii.set('W')
      expect(rotor_iii.turnover?).to eql true
    end

    it 'rotor III should rotate rotor II when "W" appears in the window' do
      rotor_iii.set('V')
      rotor_iii.left = rotor_ii
      rotor_iii.rotate!
      expect(rotor_ii.window_char).to eql 'B'
    end
  end

end

