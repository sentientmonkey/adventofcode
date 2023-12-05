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

  def normalized_engine
    @normalized_engine ||= begin
      e = []
      engine.each_with_index do |row, y|
        curr = []
        row.each_with_index do |pos, x|
          e << []
          if digit?(pos)
            curr << pos
          else
            unless curr.empty?
              ((x - curr.size)...x).each do |cx|
                e[y][cx] = curr.join.to_i
              end
              curr = []
            end
            e[y][x] = (pos if pos != '.')
          end
        end
      end
      e
    end
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
          curr.match! if neighbors(engine, x, y).any? { |d| symbol?(d) }
        end
        unless digit?(peek(engine, x, y))
          matched << curr.matched if curr.is_match
          curr.reset!
        end
      end
    end
    matched.map(&:to_i)
  end

  def gears
    matched = []
    normalized_engine.each_with_index do |row, y|
      row.each_with_index do |pos, x|
        next unless gear?(pos)

        n = unique_neighbors(normalized_engine, x, y)
        matched << n if n.size == 2
      end
    end
    matched
  end

  def gear_ratios
    gears.map { |g| g.inject(1, :*) }
  end

  def gear_ratio_checksum
    gear_ratios.sum
  end

  def neighbors(e, x, y)
    COORDS.each_with_object([]) do |r, acc|
      posx = r[0] + x
      posy = r[1] + y
      val = get_value(e, posx, posy)
      acc << val if val
    end
  end

  def unique_neighbors(e, x, y)
    neighbors(e, x, y).uniq
  end

  def get_value(e, x, y)
    return unless x >= 0 && y >= 0 && x < e.first.size && y < e.size

    e[y][x]
  end

  def peek(e, x, y)
    get_value(e, x + 1, y)
  end

  def digit?(char)
    char&.match(/[0-9]/)
  end

  def symbol?(char)
    char&.match(/[^\.0-9]/)
  end

  def gear?(char)
    char == '*'
  end

  def sum
    parts.sum
  end
end

if __FILE__ == $0
  d = Day03.new(ARGF.read)
  puts d.sum
  puts d.gear_ratio_checksum
end
