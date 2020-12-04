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
  
  FIELDS = {
    'byr' => [{range: 1920..2002}],
    'iyr' => [{range: 2010..2020}],
    'eyr' => [{range: 2020..2030}],
    'hgt' => [
      {match: /^\d+cm$/, range: 150..193},
      {match: /^\d+in$/, range: 59..76},
    ],
    'hcl' => [{match: /^#[0-9a-f]{6}$/}],
    'ecl' => [{match: /^(amb)|(blu)|(brn)|(gry)|(grn)|(hzl)|(oth)/}],
    'pid' => [{match: /^\d{9}$/}],
    'cid' => [{}],
  }

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
    rules = FIELDS[field] || []

    rules.one? do |rule|
      is_range = if rule[:range]
                   rule[:range].member? value.to_i
                 else
                   true
                 end

      value.match?(rule.fetch(:match){ /.*/ }) && is_range
    end
  end

  def valid?
    FIELDS.keys.all?{ |field| field_valid? field }
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
