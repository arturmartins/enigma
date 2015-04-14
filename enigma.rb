module Enigma
  ALPHABET = Array('A'..'Z').freeze

  ROTOR_I_MAP = %w(E K M F L G D Q V Z N T O W Y H X U S P A I B R C J).freeze
  ROTOR_II_MAP = %w(A J D K S I R U X B L H W T M C Q G Z N P Y F V O E).freeze
  ROTOR_III_MAP = %w(B D F H J L C P R T X V Z N Y E I W G A K M U S Q O).freeze

  ROTOR_I_NOTCH = 'R'
  ROTOR_II_NOTCH = 'F'
  ROTOR_III_NOTCH = 'W'

  REFLECTOR_B_MAP = %w(Y R U H Q S L D P X N G O K M I E B F Z C W V J A T).freeze

  class Machine
    def convert(char)
    end
  end

  class NullRotor
    def offset
      0
    end

    def rotate!
    end
  end

  class Component

    attr_accessor :right

    def initialize(mapping)
      @mapping = mapping
      self.right = NullRotor.new
    end
  end

  class Rotor < Component

    attr_reader :offset
    attr_accessor :left

    def initialize(mapping, notch=nil)
      super(mapping)
      @offset = 0
      @notch = notch
      self.left = NullRotor.new
    end

    def set(char)
      @offset = ALPHABET.index(char)
    end

    def window_char
      ALPHABET[@offset]
    end

    def rotate!
      @offset = (@offset + 1) % ALPHABET.length
      self.left.rotate! if self.turnover?
    end

    def forward(char)
      i = ALPHABET.index(char)
      @mapping.rotate(@offset - right.offset)[i]
    end

    def reverse(char)
      i = @mapping.rotate(@offset - right.offset).index(char)
      ALPHABET[i]
    end

    def turnover?
      window_char == @notch
    end
  end

  class Reflector < Component

    def reflect(char)
      puts char
      i = ALPHABET.index(char)
      char = @mapping.rotate(-right.offset)[i]
      puts char
      char
    end

  end

end
