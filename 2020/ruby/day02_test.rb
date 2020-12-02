#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day02.rb"

class TheLastPassTest < Minitest::Test
  def test_password_matches
    input = <<~EOS
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    EOS

    pass = TheLastPass.new input

    assert_equal 2, pass.valid_count
  end
end
