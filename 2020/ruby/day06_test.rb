require "minitest/autorun"
require "minitest/pride"

require_relative "day06.rb"

class TestQuizmaster < Minitest::Test
  def setup
    @input = <<~EOS
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
  end

  def test_group_answer
    assert_equal 3, group_answer("abc")
    assert_equal 3, group_answer("a\nb\nc")
    assert_equal 3, group_answer("ab\nac")
  end

  def test_all_answers
    assert_equal 11, all_answers(@input)
  end

  def test_group_yes
    assert_equal 3, group_yes("abc")
    assert_equal 0, group_yes("a\nb\nc")
    assert_equal 1, group_yes("ab\nac")
  end

  def test_all_yes
    assert_equal 6, all_yes(@input)
  end
end
 
