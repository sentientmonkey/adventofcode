class CurrMatch
  attr_reader :is_match

  def initialize
    reset!
  end

  def add(m)
    @matches.push(m)
  end

  def matched
    @matches.join
  end

  def match!
    @is_match = true
  end

  def reset!
    @matches = []
    @is_match = false
  end
end

class Day03
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def engine
    @engine ||= input.split("\n").map(&:chars)
  end

  COORDS = [
    [0, -1],
    [1, -1],
    [1, 0],
    [1, 1],
    [0, 1],
    [-1, 1],
    [-1, 0],
    [-1, -1]
  ].freeze

  def parts
    matched = []
    curr = CurrMatch.new
    engine.each_with_index do |row, y|
      curr.reset!
      row.each_with_index do |pos, x|
        if digit?(pos)
          curr.add(pos)
        else
          # gross
          curr.match! if neighbors(x, y).any? { |d| symbol?(d) }
          matched << curr.matched if curr.is_match
          curr.reset!
        end
        curr.match! if neighbors(x, y).any? { |d| symbol?(d) }
      end
    end
    matched.map(&:to_i)
  end

  def neighbors(x, y)
    COORDS.each_with_object([]) do |r, acc|
      posx = r[0] + x
      posy = r[1] + y
      val = get_value(posx, posy)
      acc << val if val
    end
  end

  def get_value(x, y)
    return unless x >= 0 && y >= 0 && x < engine.first.size && y < engine.size

    engine[y][x]
  end

  def digit?(char)
    char.match(/[0-9]/)
  end

  def symbol?(char)
    char.match(/[^\.0-9]/)
  end

  def sum
    parts.sum
  end
end

if __FILE__ == $0
  d = Day03.new(ARGF.read)
  puts d.sum
end
