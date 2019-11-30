#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"
require_relative "day07"

class TestCircuit < Minitest::Test
  def test_weights
    subject = Circut.new "tqefb (40)\npbga (66)"
    assert_equal 40, subject.weights["tqefb"]
    assert_equal 66, subject.weights["pbga"]
  end

  def test_tree
    subject = Circut.new "fwft (72) -> ktlj, cntj, xhth"
    assert_equal "fwft", subject.root.name
    assert_equal %w(ktlj cntj xhth), subject.root.children.map(&:name)
  end

  def test_in_order_tree
    subject = Circut.new "tknk (41) -> ugml, padx, fwft\nfwft (72) -> ktlj, cntj, xhth"
    assert_equal "tknk", subject.root.name
    assert_equal %w(ugml padx fwft), subject.root.children.map(&:name)

    fwft = subject.root.children.last
    assert_equal "fwft", fwft.name
    assert_equal %w(ktlj cntj xhth), fwft.children.map(&:name)
  end

  def test_out_of_order_tree
    subject = Circut.new "fwft (72) -> ktlj, cntj, xhth\ntknk (41) -> ugml, padx, fwft"
    assert_equal "tknk", subject.root.name
    assert_equal %w(ugml padx fwft), subject.root.children.map(&:name)

    fwft = subject.root.children.last
    assert_equal "fwft", fwft.name
    assert_equal %w(ktlj cntj xhth), fwft.children.map(&:name)
  end

  def test_full_tree
    subject = Circut.new "fwft (72) -> ktlj, cntj, xhth\ntknk (41) -> ugml, padx, fwft\nugml (68) -> gyxo, ebii, jptl"
    assert_equal "tknk", subject.root.name
    assert_equal %w(ugml padx fwft), subject.root.children.map(&:name)
  end

  def test_simple_exampe
    subject = Circut.new <<-eos
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
eos
    assert_equal "tknk", subject.root.name
    assert_equal %w(ugml padx fwft), subject.root.children.map(&:name)
    puts subject.root.to_s
  end
end

