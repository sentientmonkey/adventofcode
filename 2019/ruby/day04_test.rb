#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day04.rb"

class PasswordCrackerTest < Minitest::Test

  def setup
    @subject = PasswordCracker
  end

  def test_passwords_are_six_digits
    assert @subject.valid? 111111
    refute @subject.valid? 11111
  end

  def test_passwords_have_two_repeating_digits
    assert @subject.valid? 113456
    refute @subject.valid? 123456
  end

  def test_password_dont_increase
    assert @subject.valid? 111123
    refute @subject.valid? 223450
  end

  def test_returns_passwords_within_range
    assert_equal 9, @subject.guesses(111111, 111120).size
  end
end
