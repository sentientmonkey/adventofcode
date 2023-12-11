class Day08
  attr_reader :directions, :network, :final_node
  attr_accessor :step, :current_node

  def initialize(input)
    @step = 0
    @current_node = 'AAA'
    @final_node = 'ZZZ'
    d, n = input.split("\n\n")
    @directions = d.chars
    @network = n.split("\n").each_with_object({}) do |line, acc|
      line =~ /(\w+) = \((\w+), (\w+)\)/
      acc[::Regexp.last_match(1)] = [::Regexp.last_match(2), ::Regexp.last_match(3)]
    end
  end

  def next_direction
    self.step += 1

    directions[(step - 1) % directions.size]
  end

  def find_steps
    while current_node != final_node
      case next_direction
      when 'L'
        self.current_node = left
      when 'R'
        self.current_node = right
      end
    end
    self.step
  end

  def left
    network.fetch(current_node)[0]
  end

  def right
    network.fetch(current_node)[1]
  end
end

if __FILE__ == $0
  exercise = Day08.new ARGF.read
  puts exercise.find_steps
end
