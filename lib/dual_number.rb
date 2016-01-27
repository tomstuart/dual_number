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

  def +(argument)
    with_dual_number(argument) do |other|
      DualNumber.new \
        real: real + other.real,
        dual: dual + other.dual
    end
  end

  def -(argument)
    with_dual_number(argument) do |other|
      DualNumber.new \
        real: real - other.real,
        dual: dual - other.dual
    end
  end

  def *(argument)
    with_dual_number(argument) do |other|
      DualNumber.new \
        real: real * other.real,
        dual: real * other.dual + dual * other.real
    end
  end

  def /(argument)
    with_dual_number(argument) do |other|
      DualNumber.new \
        real: real / other.real,
        dual: (dual * other.real - real * other.dual) / (other.real * other.real)
    end
  end

  def -@
    self * -1
  end

  def **(power)
    DualNumber.new \
      real: real ** power,
      dual: power * dual * (real ** (power - 1))
  end

  def coerce(other)
    [DualNumber(other), self]
  end

  private

  def with_dual_number(argument)
    yield DualNumber(argument)
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

Math.singleton_class.prepend Module.new {
  def self.def_for_dual_number(method_name, &block)
    define_method method_name do |arg, *args|
      case arg
      when DualNumber
        instance_exec arg, *args, &block
      else
        super arg, *args
      end
    end
  end

  def_for_dual_number :sin do |x|
    DualNumber.new \
      real: sin(x.real),
      dual: x.dual * cos(x.real)
  end

  def_for_dual_number :cos do |x|
    DualNumber.new \
      real: cos(x.real),
      dual: -x.dual * sin(x.real)
  end
}
