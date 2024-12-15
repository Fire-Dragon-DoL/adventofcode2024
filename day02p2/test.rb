require_relative "src"

require "pry-byebug"

INPUTS = [
  [[16, 18, 20, 22, 23, 22], true]
]

module Day02p2Test
  extend self

  def run
    INPUTS.each_with_index do |data, idx|
      levels, is_safe = data
      report = Report.new(levels)
      if report.safe? != is_safe
        puts "Report #{idx} broken"
        binding.pry
        puts "Expected safety: #{is_safe}"
      end
    end
    puts "Done"
  end
end

Day02p2Test.run
