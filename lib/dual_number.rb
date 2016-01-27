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

  def +(other)
    DualNumber.new \
      real: real + other.real,
      dual: dual + other.dual
  end

  def -(other)
    DualNumber.new \
      real: real - other.real,
      dual: dual - other.dual
  end

  def *(other)
    DualNumber.new \
      real: real * other.real,
      dual: real * other.dual + dual * other.real
  end

  def /(other)
    DualNumber.new \
      real: real / other.real,
      dual: (dual * other.real - real * other.dual) / (other.real * other.real)
  end

  def coerce(other)
    [DualNumber(other), self]
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
