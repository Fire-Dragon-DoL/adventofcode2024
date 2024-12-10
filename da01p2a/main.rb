require_relative "../aoc/aoc"

module Day01p2
  extend self

  def run
    parsed = File.
      foreach("input.txt").
      lazy.
      map { |line| parse(line) }.
      reject(&:nil?)
    occurrences = Hash.new(0)
    list = []
    parsed.each do |lr|
      left, right = lr
      occurrences[right] += 1
      list << left
    end

    AOC.dbg("List/Occurrences:")
    AOC.ap(list)
    AOC.ap(occurrences)

    sscore = 0
    list.each do |left|
      num_sscore = occurrences[left] * left
      sscore += num_sscore
    end

    puts(sscore.to_s)
  end

  LINE_REGEX = /\s*(?<left>\d+)\s+(?<right>\d+)\s*/

  def parse(line)
    matches = LINE_REGEX.match(line)
    return nil if matches.nil?

    [Integer(matches[:left]), Integer(matches[:right])]
  rescue => err
    AOC.dbg("parse error: " + err.ai)
    nil
  end
end

Day01p2.run
