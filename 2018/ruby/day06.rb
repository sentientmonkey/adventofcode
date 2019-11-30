#!/usr/bin/env ruby -w

if __FILE__ == $0
  if ARGV.empty?
    require "minitest/autorun"
    require "minitest/pride"

    class DeviceTest < Minitest::Test
      COORDS = <<~EOS
                  1, 1
                  1, 6
                  8, 3
               EOS

      def test_list_to_coorindates

      end
    end
  else
    input = ARGF.read.chomp
    puts input
  end
end
