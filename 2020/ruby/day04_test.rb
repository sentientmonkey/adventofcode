#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day04.rb"

class PassportCheckerTest < Minitest::Test
  def setup
    input = <<~EOS
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    EOS
    @checker = PassportChecker.new input
  end

  def test_passport_records
    assert_equal 4, @checker.count
    record = @checker[0]

    assert_equal 'gry',       record['ecl']
    assert_equal '860033327', record['pid']
    assert_equal '2020',      record['eyr']
    assert_equal '#fffffd',   record['hcl']
    assert_equal '1937',      record['byr']
    assert_equal '2017',      record['iyr']
    assert_equal '147',       record['cid']
    assert_equal '183cm',     record['hgt']
  end

  def test_passports_valid
    assert @checker[0].valid?
    refute @checker[1].valid?
    assert @checker[2].valid?
    refute @checker[3].valid?

    assert_equal 2, @checker.valid_count
  end
end
