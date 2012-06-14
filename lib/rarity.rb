require "rarity/version"

module Rarity
  def self.to_human(number)
    units = %w{B KB MB GB TB}
    if number > 0
      e = (Math.log(number)/Math.log(1024)).floor
      s = "%.3f" % (number.to_f / 1024**e)
      return s.sub(/\.?0*$/, units[e])
    else
      return "0 B"
    end
  end
end
require "rarity/tracker"
require "rarity/optimiser"
require "rarity/runner"