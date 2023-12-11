class Day08
  attr_reader :directions, :network, :final_nodes
  attr_accessor :step, :current_nodes

  def initialize(input, ghost_mode: false)
    @step = 0
    @current_nodes = []
    @final_nodes = []
    d, n = input.split("\n\n")
    @directions = d.chars
    start_key = 'AAA'
    end_key = 'ZZZ'
    if ghost_mode
      start_key = 'A'
      end_key = 'Z'
    end
    @network = n.split("\n").each_with_object({}) do |line, acc|
      line =~ /(\w+) = \((\w+), (\w+)\)/
      node = ::Regexp.last_match(1)
      acc[node] = [::Regexp.last_match(2), ::Regexp.last_match(3)]
      if node.end_with? start_key
        @current_nodes << node
      elsif node.end_with? end_key
        @final_nodes << node
      end
    end
  end

  def current_node
    current_nodes.first
  end

  def final_node
    final_nodes.first
  end

  def next_direction
    self.step += 1

    directions[(step - 1) % directions.size]
  end

  def at_end?
    current_nodes.all? do |c|
      c.end_with? 'Z'
    end
  end

  def find_steps
    until at_end?
      # pp step
      # pp current_nodes
      case next_direction
      when 'L'
        self.current_nodes = left
      when 'R'
        self.current_nodes = right
      end
    end
    self.step
  end

  def fetch_current
    current_nodes.map do |curr|
      network.fetch(curr)
    end
  end

  def left
    fetch_current.map(&:first)
  end

  def right
    fetch_current.map(&:last)
  end
end

if __FILE__ == $0
  input = ARGF.read
  exercise = Day08.new input
  puts exercise.find_steps
  exercise = Day08.new input, ghost_mode: true
  puts exercise.find_steps
end
