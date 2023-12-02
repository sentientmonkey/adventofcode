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
end

puts Day02.new(ARGF.read).checksum if __FILE__ == $0
