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

  def field_valid? field, value
    passport = Passport.new("#{field}:#{value}")
    passport.field_valid?(field)
  end

  def test_bry
    refute field_valid? "byr", 1919
    assert field_valid? "byr", 1920
    assert field_valid? "byr", 2002
    refute field_valid? "byr", 2003
  end

  def test_iry
    refute field_valid? "iyr", 2009
    assert field_valid? "iyr", 2010
    assert field_valid? "iyr", 2020
    refute field_valid? "iyr", 2021
  end

  def test_hgt
    refute field_valid? "hgt", "149cm"
    assert field_valid? "hgt", "150cm"
    assert field_valid? "hgt", "193cm"
    refute field_valid? "hgt", "194cm"

    refute field_valid? "hgt", "58in"
    assert field_valid? "hgt", "59in"
    assert field_valid? "hgt", "76in"
    refute field_valid? "hgt", "77in"
  end

  def test_hcl
    assert field_valid? "hcl", "#123abc"
    refute field_valid? "hcl", "#123abz"
    refute field_valid? "hcl", "123abc"
  end

  def test_ecl
    assert field_valid? "ecl", "brn"
    refute field_valid? "ecl", "wat"
  end

  def test_pid
    assert field_valid? "pid", "000000001"
    refute field_valid? "pid", "0123456789"
  end

  def test_cid
    assert field_valid? "cid", "whatev"
    assert Passport.new.field_valid? "cid"
  end

  def passport_valid? record
    Passport.new(record).valid?
  end

  def test_valid
    checker = PassportChecker.new <<~EOS
    pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
    hcl:#623a2f

    eyr:2029 ecl:blu cid:129 byr:1989
    iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

    hcl:#888785
    hgt:164cm byr:2001 iyr:2015 cid:88
    pid:545766238 ecl:hzl
    eyr:2022

    iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
    EOS

    assert_equal 4, checker.valid_count
  end

  def test_invalid
    checker = PassportChecker.new <<~EOS
    eyr:1972 cid:100
    hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

    iyr:2019
    hcl:#602927 eyr:1967 hgt:170cm
    ecl:grn pid:012533040 byr:1946

    hcl:dab227 iyr:2012
    ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

    hgt:59cm ecl:zzz
    eyr:2038 hcl:74454a iyr:2023
    pid:3556412378 byr:2007
    EOS

    assert_equal 0, checker.valid_count
  end
end
