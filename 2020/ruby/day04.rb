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
  FIELDS = %w(byr iyr eyr hgt hcl ecl pid cid)

  def initialize record=""
    @values = {}
    parse record
  end

  def parse record
    record.split(/\s+/).each_with_object(self) do |col,hash|
      key, value = col.split ':'
      hash[key] = value
    end
  end

  def [](key)
    @values[key]
  end

  def []=(key, value)
    @values[key] = value
  end

  def field_valid? field
    value = @values[field].to_s
    case field
    when 'byr'
      value.to_i.between?(1920,2002)
    when 'iyr'
      value.to_i.between?(2010,2020)
    when 'eyr'
      value.to_i.between?(2020,2030)
    when 'hgt'
      (value.match?(/^\d+cm$/) && value.to_i.between?(150,193)) ||
        (value.match?(/^\d+in$/) && value.to_i.between?(59,76))
    when 'hcl'
      value.match?(/^#[0-9a-f]{6}/)
    when 'ecl'
      %w(amb blu brn gry grn hzl oth).include? value
    when 'pid'
      value.match?(/^\d{9}$/)
    when 'cid'
      true
    end
  end

  def valid?
    FIELDS.all?{ |field| field_valid? field }
  end
end

class PassportChecker
  def initialize input
    @records = input.split(/\n{2}/).map { |r| Passport.new r }
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
