class DualNumber
  attr_accessor :real, :dual
  private :real=, :dual=

  def initialize(real:, dual:)
    self.real = real
    self.dual = dual
  end

  def to_s
    [real, (dual < 0 ? '-' : '+'), dual.abs, 'ε'].join
  end

  def inspect
    "(#{to_s})"
  end

  def ==(other)
    other.instance_of?(DualNumber) && [real, dual] == [other.real, other.dual]
  end
end

module Kernel
  def DualNumber(real, dual = 0)
    case real
    when DualNumber
      real
    else
      DualNumber.new(real: real, dual: dual)
    end
  end
end
