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
    curr = []
    is_match = false
    engine.each_with_index do |row, y|
      row.each_with_index do |pos, x|
        curr << pos
        unless digit?(pos)
          matched << curr.join if is_match
          curr = []
          is_match = false
          next
        end
        is_match = true if neighbors(x, y).any? { |d| symbol?(d) }
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
