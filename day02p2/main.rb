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
    return false if !safe_pair?(current, prev)

    true
  end

  def self.unsafe_pair_index(levels, ton)
    prev = levels[0]
    levels.drop(1).each.with_index(1) do |current, idx|
      return [idx - 1, idx] if !safe_seq?(ton, prev, current)

      prev = current
    end
    nil
  end

  def self.safe_levels?(levels, ton)
    unsafe_pair_index(levels, ton).nil?
  end

  def self.tonicity(levels)
    last = levels[0]
    slast = levels[1]
    return :dec if last > slast
    :inc
  end

  private

  def compute_safety
    inc_unsafe_idx = self.class.unsafe_pair_index(@levels, :inc)
    dec_unsafe_idx = self.class.unsafe_pair_index(@levels, :dec)
    inc1_maybe_safe = @levels
    inc2_maybe_safe = @levels
    dec1_maybe_safe = @levels
    dec2_maybe_safe = @levels
    if !inc_unsafe_idx.nil?
      inc1_maybe_safe = @levels.dup.tap{|i| i.delete_at(inc_unsafe_idx[0])}
      inc2_maybe_safe = @levels.dup.tap{|i| i.delete_at(inc_unsafe_idx[1])}
    end
    if !dec_unsafe_idx.nil?
      dec1_maybe_safe = @levels.dup.tap{|i| i.delete_at(dec_unsafe_idx[0])}
      dec2_maybe_safe = @levels.dup.tap{|i| i.delete_at(dec_unsafe_idx[1])}
    end
    ton = self.class.tonicity(inc1_maybe_safe)
    inc1_safe = self.class.safe_levels?(inc1_maybe_safe, ton)
    ton = self.class.tonicity(inc1_maybe_safe)
    inc2_safe = self.class.safe_levels?(inc2_maybe_safe, ton)
    ton = self.class.tonicity(dec1_maybe_safe)
    dec1_safe = self.class.safe_levels?(dec1_maybe_safe, ton)
    ton = self.class.tonicity(dec1_maybe_safe)
    dec2_safe = self.class.safe_levels?(dec2_maybe_safe, ton)

    dec1_safe || dec2_safe || inc1_safe || inc2_safe
    # last = @levels[0]
    # slast = @levels[1]
    # ton = :inc
    # if last > slast
    #   ton = :dec
    # end

    # skipped = 0
    # prev = @levels[0]
    # dlevels = @levels.reject do |current|
    #   if skipped < 1 && !self.class.safe_seq?(ton, current, prev)
    #     skipped += 1
    #     next true
    #   end
    #   prev = current
    #   false
    # end

    # prev = dlevels[0]
    # @levels.drop(1).each do |current|
    #   return false if self.class.safe_seq?(ton, current, prev)

    #   prev = current
    # end

    # skipped <= 1
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
