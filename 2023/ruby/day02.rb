MARBLES = {
  red: 12,
  green: 13,
  blue: 14
}.freeze

Game = Data.define(:number, :rounds) do
  def valid?
    rounds.all? do |guesses|
      guesses.all? do |color, number|
        number <= MARBLES.fetch(color)
      end
    end
  end

  def min_cubes
    rounds.each_with_object({}) do |guesses, mins|
      guesses.each do |color, count|
        mins[color] = [mins.fetch(color, 0), count].max
      end
    end
  end

  def power
    min_cubes.values.inject(1, :*)
  end
end

class Day02
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def games
    input.split("\n").map do |line|
      match = line.match(/Game (\d+): (.*)$/)
      number = match[1].to_i
      rounds = match[2].split('; ').map do |round|
        round.split(', ').each_with_object({}) do |guess, acc|
          count, color = guess.split
          acc[color.to_sym] = count.to_i
        end
      end
      Game.new(number: number, rounds: rounds)
    end
  end

  def valid_games
    games.select(&:valid?)
  end

  def checksum
    valid_games.map(&:number).sum
  end

  def powersum
    games.map(&:power).sum
  end
end

if __FILE__ == $0
  d = Day02.new(ARGF.read)
  puts d.checksum
  puts d.powersum
end
