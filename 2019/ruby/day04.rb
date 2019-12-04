#!/usr/bin/env ruby -w

class PasswordCracker
  def self.valid? password
    chars = password.to_s.chars
    chars.size == 6 &&
     chars.uniq.size != 6 &&
     chars.each_cons(2).all?{|p| p[0] <= p[1] }
  end

  def self.guesses b, e 
    (b...e).select{|p| valid? p }
  end
end

if __FILE__ == $0
  puts PasswordCracker.guesses(372037, 905157).size
end
