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

  def self.unsafe_seq_index(levels, ton)
    prev = levels[0]
    levels.drop(1).each.with_index(1) do |current, idx|
      return [idx - 1, idx] if !safe_seq?(ton, prev, current)

      prev = current
    end
    nil
  end

  def self.discard_level_index(levels, ton)
    prev = levels[0]
    levels.drop(1).each.with_index(1) do |current, idx|
      if safe_seq?(ton, prev, current)
        prev = current
        next
      end

      # prevprev
      if (idx - 1) >= 0
        prevprev = levels[idx - 1]
        if safe_seq?(ton, prevprev, prev)
          return idx
        end
        if safe_seq?(ton, prevprev, current)
          return idx - 1
        end
      end

      # future
      if (idx + 1) < levels.size
        future = levels[idx + 1]
        if safe_seq?(ton, prev, future)
          return idx
        end
        if safe_seq?(ton, current, future)
          return idx - 1
        end
      end

      prev = current
    end

    nil
  end

  def self.safe_levels?(levels, ton)
    prev = levels[0]
    levels.drop(1).each do |current|
      return false if !safe_seq?(ton, prev, current)

      prev = current
    end
    true
  end
  # def self.safe_levels?(levels, ton)
  #   unsafe_seq_index(levels, ton).nil?
  # end

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

    # maybe_safe_levels = @levels.dup
    # ton = self.class.tonicity(maybe_safe_levels)
    # discard_level = self.class.discard_level_index(maybe_safe_levels, ton)
    # if discard_level
    #   maybe_safe_levels = maybe_safe_levels.tap{|i| i.delete_at(discard_level)}
    # end
    # # debug info
    # @discarded = discard_level
    # @ton = ton

    # self.class.safe_levels?(maybe_safe_levels, ton)

    # inc_unsafe_idx = self.class.unsafe_seq_index(@levels, :inc)
    # dec_unsafe_idx = self.class.unsafe_seq_index(@levels, :dec)
    # inc1_maybe_safe = @levels
    # inc2_maybe_safe = @levels
    # dec1_maybe_safe = @levels
    # dec2_maybe_safe = @levels
    # if !inc_unsafe_idx.nil?
    #   inc1_maybe_safe = @levels.dup.tap{|i| i.delete_at(inc_unsafe_idx[0])}
    #   inc2_maybe_safe = @levels.dup.tap{|i| i.delete_at(inc_unsafe_idx[1])}
    # end
    # if !dec_unsafe_idx.nil?
    #   dec1_maybe_safe = @levels.dup.tap{|i| i.delete_at(dec_unsafe_idx[0])}
    #   dec2_maybe_safe = @levels.dup.tap{|i| i.delete_at(dec_unsafe_idx[1])}
    # end
    # ton = self.class.tonicity(inc1_maybe_safe)
    # inc1_safe = self.class.safe_levels?(inc1_maybe_safe, ton)
    # ton = self.class.tonicity(inc1_maybe_safe)
    # inc2_safe = self.class.safe_levels?(inc2_maybe_safe, ton)
    # ton = self.class.tonicity(dec1_maybe_safe)
    # dec1_safe = self.class.safe_levels?(dec1_maybe_safe, ton)
    # ton = self.class.tonicity(dec1_maybe_safe)
    # dec2_safe = self.class.safe_levels?(dec2_maybe_safe, ton)

    # dec1_safe || dec2_safe || inc1_safe || inc2_safe
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
