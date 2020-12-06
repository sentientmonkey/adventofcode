require "minitest/autorun"
require "minitest/pride"

require_relative "day06.rb"

class TestQuizmaster < Minitest::Test
  def setup
  end

  def test_group_answer
    assert_equal 3, group_answer("abc")
    assert_equal 3, group_answer("a\nb\nc")
    assert_equal 3, group_answer("ab\nac")
  end

  def test_all_answers
    input = <<~EOS
               abc
 
               a
               b
               c
 
               ab
               ac
 
               a
               a
               a
               a
 
               b
               EOS
    assert_equal 11, all_answers(input)
  end
end
 
