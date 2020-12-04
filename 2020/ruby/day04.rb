#!/usr/bin/env ruby -w

class Passport
  # byr (Birth Year)
  # iyr (Issue Year)
  # eyr (Expiration Year)
  # hgt (Height)
  # hcl (Hair Color)
  # ecl (Eye Color)
  # pid (Passport ID)
  # cid (Country ID)
  def initialize
    @values = {}
  end

  def [](key)
    @values[key]
  end

  def []=(key, value)
    @values[key] = value
  end

  def valid?
    @values.length == 8 ||
      (@values.length == 7 && !@values['cid'])
  end
end

class PassportChecker
  def initialize input
    @records = input.split(/\n{2}/).map do |record|
      record.split(/\s+/).each_with_object(Passport.new) do |col,hash|
        key, value = col.split ':'
        hash[key] = value
      end
    end
  end

  def [](index)
    @records[index]
  end

  def count
    @records.count
  end

  def valid_count
    @records.count(&:valid?)
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  checker = PassportChecker.new input
  puts checker.valid_count
end
