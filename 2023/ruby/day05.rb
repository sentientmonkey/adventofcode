Map = Data.define(:source, :dest, :mappings) do
  def lookup(n)
    mappings.each do |k, v|
      return n + v if k.cover?(n)
    end
    n
  end

  def lookup_range(r)
    results = []
    mappings.each do |k, v|
      pp "k=#{k}, r=#{r}, v=#{v}"
      next unless k.cover?(r)

      results << Range.new(r.begin + v, r.end + v)
    end
    results << r if results.empty?

    results
  end
end

class Day05
  attr_reader :input, :seeds, :maps

  def initialize(input)
    @seeds = []
    @maps = []
    input.split("\n\n").each do |section|
      case section
      when /seeds: /
        @seeds = section.scan(/\d+/).map(&:to_i)
      when /([a-z]+)-to-([a-z]+) map:/
        map = Map.new(*Regexp.last_match[1..2], [])
        section.split("\n")[1..].each do |line|
          dest, source, len = line.split.map(&:to_i)
          map.mappings << [source..(source + len), dest - source]
        end

        @maps << map
      end
    end
  end

  def find_location(seed)
    maps.inject(seed) do |location, map|
      map.lookup(location)
    end
  end

  def lowest_location
    seeds.map { |s| find_location(s) }.min
  end

  def lowest_location_ranges
    seeds.each_slice(2).map do |a, b|
      Ractor.new(a, b, self) do |ra, rb, k|
        ra.upto(ra + rb).map do |s|
          k.find_location(s)
        end
      end
    end.map(&:take).min.min
  end
end

if __FILE__ == $0
  d = Day05.new(ARGF.read)
  puts d.lowest_location
  puts d.lowest_location_ranges
end
