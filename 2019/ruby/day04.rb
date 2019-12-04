#!/usr/bin/env ruby -w

class PasswordCracker
  def self.valid? password
    chars = password.to_s.chars
    pairs = chars.each_cons(2).to_a
    chars.size == 6 &&
     pairs.all?{|p| p[0] <= p[1] } &&
     pairs.any? do |a| 
       a == a.reverse &&
         pairs.select{|b| a == b}.size == 1 
     end
  end

  def self.guesses b, e 
    (b...e).select{|p| valid? p }
  end
end

if __FILE__ == $0
  puts PasswordCracker.guesses(372037, 905157).size
end
