class DualNumber
  attr_accessor :real, :dual
  private :real=, :dual=

  def initialize(real:, dual:)
    self.real = real
    self.dual = dual
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
