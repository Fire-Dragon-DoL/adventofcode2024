require_relative "src"

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
