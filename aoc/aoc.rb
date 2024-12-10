require "amazing_print"

module AOC
  extend self

  def debug?
    ENV["DEBUG"] == "on"
  end

  def dbg(msg)
    return if !debug?
    puts(msg)
  end

  def ap(...)
    return if !debug?
    Kernel.ap(...)
  end
end
