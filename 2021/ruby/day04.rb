#!/usr/bin/env ruby -w

class SquidBingo
  attr_reader :numbers, :cards, :marked, :winning_card, :score, :winners

  def initialize(input)
    @winners = []
    @cards = []
    @marked = []
    card = []

    input.split("\n").each do |line|
      if @numbers
        if line == ""
          next if card.empty?
          @cards = @cards.push card
          card = []
        else
          card = card.push line.split(' ').map(&:to_i)
        end
      else
        @numbers = line.split(",").map(&:to_i)
      end
    end
    @cards = @cards.push card

    @marked = @cards.map{|x| x.map { |y| y.map { false }}}
  end

  def draw
    called = numbers.shift
    cards.each_with_index do |card,idx|
      card.each_with_index do |row,y|
        row.each_with_index do |number,x|
          if number == called
            marked[idx][y][x] = true
          end
        end
      end
    end
    called
  end

  def play
    number = nil
    while !winning_card && !numbers.empty?
      number = draw
      @winning_card = find_winner
    end
    @score = number * unmarked_sum
  end

  def play_all
    number = nil
    while winners.size < cards.size && !numbers.empty?
      number = draw
      @winners = (@winners + find_winners).uniq
    end
    @score = number * last_unmarked_sum
  end

 def find_winner
    marked.each_with_index do |card,idx|
      return idx+1 if card.any?{|row| row.all?{|m| m } }
      return idx+1 if card.transpose.any?{|row| row.all?{|m| m } }
    end
    nil
  end

  def find_winners
    marked.each_with_index.reduce([]) do |acc,(card,idx)|
      if card.any?{|row| row.all?{|m| m } } ||
          card.transpose.any?{|row| row.all?{|m| m } }
       acc << idx+1
      end
      acc
    end
  end

  def unmarked_sum
    total = 0
    cards[winning_card-1].each_with_index do |row,y|
      row.each_with_index do |number,x|
        unless marked[winning_card-1][y][x]
          total += cards[winning_card-1][y][x]
        end
      end
    end
    total
  end

  def last_unmarked_sum
    total = 0
    last_winner = winners.last
    cards[last_winner-1].each_with_index do |row,y|
      row.each_with_index do |number,x|
        unless marked[last_winner-1][y][x]
          total += cards[last_winner-1][y][x]
        end
      end
    end
    total
  end

end

if __FILE__ == $0
  input = ARGF.read.chomp
  bingo = SquidBingo.new(input)
  bingo.play
  puts bingo.score
  bingo = SquidBingo.new(input)
  bingo.play_all
  puts bingo.score
end
