require_relative "../aoc/aoc"

require "csv"

class Report
  def initialize(levels)
    @levels = levels
    if levels.size.zero?
      raise "Empty levels"
    end
  end

  def safe?
    @is_safe ||= compute_safety
  end

  def to_s
    safety = "danger,"
    safety = "safe,  " if safe?
    "Report[#{safety} #{@levels.inspect}]"
  end

  def self.safe_pair?(a, b)
    (a - b).abs <= 3
  end

  private

  def compute_safety
    last = @levels[0]
    slast = @levels[1]
    ton = :inc
    if last > slast
      ton = :dec
    end

    prev = @levels[0]
    @levels.drop(1).each do |current|
      return false if current == prev
      return false if ton == :inc && current < prev
      return false if ton == :dec && current > prev
      return false if !self.class.safe_pair?(current, prev)

      prev = current
    end

    true
  end
end

module Day02
  extend self

  def run
    safe_reports = CSV.
      foreach("input.txt", col_sep: " ").
      lazy.
      map { |line| parse(line) }.
      reject(&:nil?).
      reject(&:empty?).
      map { |row| Report.new(row) }.
      yield_self { |reports| AOC.ap(reports.map(&:to_s).force); reports }.
      count(&:safe?)

    puts(safe_reports.to_s)
  end

  def parse(row)
    row.map { |tn| Integer(tn)}
  rescue => err
    AOC.dbg("parse error: " + err.ai)
    nil
  end
end

Day02.run
