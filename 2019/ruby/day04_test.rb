#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day04.rb"

class PasswordCrackerTest < Minitest::Test

  def setup
    @subject = PasswordCracker
  end

  def test_passwords_are_six_digits
    assert @subject.valid? 112345
    refute @subject.valid? 11111
  end

  def test_passwords_have_two_repeating_digits
    assert @subject.valid? 113456
    refute @subject.valid? 123456
  end

  def test_password_dont_increase
    assert @subject.valid? 112345
    refute @subject.valid? 223450
  end

  def test_returns_passwords_within_range
    assert_equal 1, @subject.guesses(112290, 112300).size
  end

  def test_two_adjacent_chars
    assert @subject.valid? 112233
    refute @subject.valid? 123444
    assert @subject.valid? 111122
  end
end
