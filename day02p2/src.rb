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
    diff = (a - b).abs
    diff <= 3 && diff > 0
  end

  def self.safe_seq?(ton, prev, current)
    return false if ton == :inc && current < prev
    return false if ton == :dec && current > prev
    return false if !safe_pair?(prev, current)

    true
  end

  def self.safe_levels?(levels, ton)
    prev = levels[0]
    levels.drop(1).each do |current|
      return false if !safe_seq?(ton, prev, current)

      prev = current
    end
    true
  end

  def self.tonicity(levels)
    tons = []
    prev = levels[0]
    levels.drop(1).each do |current|
      tons << :inc if prev < current
      tons << :eq if prev == current
      tons << :dec if prev > current
      prev = current
    end
    grps = tons.tally
    dec = grps[:dec] || 0
    inc = grps[:inc] || 0
    return :dec if dec > inc
    :inc
  end

  def self.permutations(levels)
    without_level = levels.size.times.lazy.map do |idx|
      levels.dup.tap{|i| i.delete_at(idx)}
    end
    [levels].each.lazy + without_level
  end

  private

  def compute_safety
    levels = @levels.dup
    perms = self.class.permutations(levels)
    perms.any? do |current_levels|
      ton = self.class.tonicity(current_levels)
      self.class.safe_levels?(current_levels, ton)
    end
  end
end
