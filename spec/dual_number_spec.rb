require 'dual_number'

RSpec.describe 'dual numbers' do
  describe 'constructor (and getters)' do
    context 'with a real argument' do
      let(:result) { DualNumber(2) }

      it 'creates a dual number' do
        expect(result).to be_a DualNumber
      end

      it 'uses the real part' do
        expect(result.real).to eq 2
      end

      it 'uses zero for the dual part' do
        expect(result.dual).to be_zero
      end
    end

    context 'with real and dual arguments' do
      let(:result) { DualNumber(2, 3) }

      it 'creates a dual number' do
        expect(result).to be_a DualNumber
      end

      it 'uses the real part' do
        expect(result.real).to eq 2
      end

      it 'uses the dual part' do
        expect(result.dual).to eq 3
      end
    end

    context 'with an argument that’s already a dual number' do
      let(:result) { DualNumber(DualNumber(2, 3)) }

      it 'creates a dual number' do
        expect(result).to be_a DualNumber
      end

      it 'uses the real part' do
        expect(result.real).to eq 2
      end

      it 'uses the dual part' do
        expect(result.dual).to eq 3
      end
    end
  end

  describe 'string representation' do
    specify { expect(DualNumber(2, 3).to_s).to eq '2+3ε' }
    specify { expect(DualNumber(2, -3).to_s).to eq '2-3ε' }

    specify { expect(DualNumber(2, 3).inspect).to eq '(2+3ε)' }
    specify { expect(DualNumber(2, -3).inspect).to eq '(2-3ε)' }
  end

  describe 'equality' do
    context 'when the real and dual parts are equal' do
      it 'returns true' do
        expect(DualNumber(2, 3)).to eq DualNumber(2, 3)
      end
    end

    context 'when the real parts are not equal' do
      it 'returns false' do
        expect(DualNumber(2, 3)).not_to eq DualNumber(5, 3)
      end
    end

    context 'when the dual parts are not equal' do
      it 'returns false' do
        expect(DualNumber(2, 3)).not_to eq DualNumber(2, 5)
      end
    end

    context 'when the other object is not a dual number' do
      it 'returns false' do
        expect(DualNumber(2, 3)).not_to eq 5
      end
    end
  end

  describe 'arithmetic' do
    describe 'addition' do
      let(:result) { DualNumber(2, 3) + DualNumber(5, 7) }

      it 'adds the real parts' do
        expect(result.real).to eq 2 + 5
      end

      it 'adds the dual parts' do
        expect(result.dual).to eq 3 + 7
      end
    end

    describe 'subtraction' do
      let(:result) { DualNumber(2, 3) - DualNumber(5, 7) }

      it 'subtracts the real parts' do
        expect(result.real).to eq 2 - 5
      end

      it 'subtracts the dual parts' do
        expect(result.dual).to eq 3 - 7
      end
    end

    describe 'multiplication' do
      let(:result) { DualNumber(2, 3) * DualNumber(5, 7) }

      it 'multiplies the real parts' do
        expect(result.real).to eq 2 * 5
      end

      it 'multiplies opposite parts and sums them to get the dual part' do
        expect(result.dual).to eq (2 * 7) + (3 * 5)
      end
    end

    describe 'division' do
      let(:result) { DualNumber(2.0, 3.0) / DualNumber(5.0, 7.0) }

      it 'divides the real parts' do
        expect(result.real).to be_roughly 2.0 / 5.0
      end

      it 'multiplies opposite parts, subtracts them and divides by the square of the real divisor to get the dual part' do
        expect(result.dual).to be_roughly ((3.0 * 5.0) - (2.0 * 7.0)) / (5.0 * 5.0)
      end
    end

    describe 'unary negation' do
      let(:result) { -DualNumber(2, 3) }

      it 'negates the real part' do
        expect(result.real).to eq(-2)
      end

      it 'negates the dual part' do
        expect(result.dual).to eq(-3)
      end
    end

    describe 'exponentiation' do
      let(:result) { DualNumber(2, 3) ** 5 }

      it 'raises the real part to the power' do
        expect(result.real).to eq 32
      end

      it 'multiplies the power, the dual part and the real part raised to the previous power to get the dual part' do
        expect(result.dual).to eq 240
      end
    end

    describe 'automatic coercion' do
      context 'of the left operand' do
        let(:a) { 2.0 }
        let(:b) { DualNumber(3.0, 5.0) }

        specify { expect(a + b).to eq DualNumber(a) + b }
        specify { expect(a - b).to eq DualNumber(a) - b }
        specify { expect(a * b).to eq DualNumber(a) * b }
        specify { expect(a / b).to eq DualNumber(a) / b }
      end

      context 'of the right operand' do
        let(:a) { DualNumber(2.0, 3.0) }
        let(:b) { 5.0 }

        specify { expect(a + b).to eq a + DualNumber(b) }
        specify { expect(a - b).to eq a - DualNumber(b) }
        specify { expect(a * b).to eq a * DualNumber(b) }
        specify { expect(a / b).to eq a / DualNumber(b) }
      end
    end
  end

  describe 'mathematical functions' do
    describe 'sine' do
      def position_at(time:)
        Math.sin(time)
      end

      specify { expect(position_at(time: 0)).to be_roughly 0 }
      specify { expect(position_at(time: Math::PI / 2)).to be_roughly 1 }
      specify { expect(position_at(time: Math::PI)).to be_roughly 0 }
      specify { expect(position_at(time: 3 * (Math::PI / 2))).to be_roughly(-1) }

      specify { expect(position_at(time: DualNumber(0, 1)).real).to be_roughly 0 }
      specify { expect(position_at(time: DualNumber(Math::PI / 2, 1)).real).to be_roughly 1 }
      specify { expect(position_at(time: DualNumber(Math::PI, 1)).real).to be_roughly 0 }
      specify { expect(position_at(time: DualNumber(3 * (Math::PI / 2), 1)).real).to be_roughly(-1) }

      specify { expect(position_at(time: DualNumber(0, 1)).dual).to be_roughly 1 }
      specify { expect(position_at(time: DualNumber(Math::PI / 2, 1)).dual).to be_roughly 0 }
      specify { expect(position_at(time: DualNumber(Math::PI, 1)).dual).to be_roughly(-1) }
      specify { expect(position_at(time: DualNumber(3 * (Math::PI / 2), 1)).dual).to be_roughly 0 }
    end

    describe 'cosine' do
      def position_at(time:)
        Math.cos(time)
      end

      specify { expect(position_at(time: 0)).to be_roughly 1 }
      specify { expect(position_at(time: Math::PI / 2)).to be_roughly 0 }
      specify { expect(position_at(time: Math::PI)).to be_roughly(-1) }
      specify { expect(position_at(time: 3 * (Math::PI / 2))).to be_roughly 0 }

      specify { expect(position_at(time: DualNumber(0, 1)).real).to be_roughly 1 }
      specify { expect(position_at(time: DualNumber(Math::PI / 2, 1)).real).to be_roughly 0 }
      specify { expect(position_at(time: DualNumber(Math::PI, 1)).real).to be_roughly(-1) }
      specify { expect(position_at(time: DualNumber(3 * (Math::PI / 2), 1)).real).to be_roughly 0 }

      specify { expect(position_at(time: DualNumber(0, 1)).dual).to be_roughly 0 }
      specify { expect(position_at(time: DualNumber(Math::PI / 2, 1)).dual).to be_roughly(-1) }
      specify { expect(position_at(time: DualNumber(Math::PI, 1)).dual).to be_roughly 0 }
      specify { expect(position_at(time: DualNumber(3 * (Math::PI / 2), 1)).dual).to be_roughly 1 }
    end

    describe 'natural exponential' do
      def position_at(time:)
        Math.exp(time)
      end

      specify { expect(position_at(time: 0)).to be_roughly Math::E ** 0 }
      specify { expect(position_at(time: 1)).to be_roughly Math::E ** 1 }
      specify { expect(position_at(time: 2)).to be_roughly Math::E ** 2 }
      specify { expect(position_at(time: 3)).to be_roughly Math::E ** 3 }

      specify { expect(position_at(time: DualNumber(0, 1)).real).to be_roughly Math::E ** 0 }
      specify { expect(position_at(time: DualNumber(1, 1)).real).to be_roughly Math::E ** 1 }
      specify { expect(position_at(time: DualNumber(2, 1)).real).to be_roughly Math::E ** 2 }
      specify { expect(position_at(time: DualNumber(3, 1)).real).to be_roughly Math::E ** 3 }

      specify { expect(position_at(time: DualNumber(0, 1)).dual).to be_roughly Math::E ** 0 }
      specify { expect(position_at(time: DualNumber(1, 1)).dual).to be_roughly Math::E ** 1 }
      specify { expect(position_at(time: DualNumber(2, 1)).dual).to be_roughly Math::E ** 2 }
      specify { expect(position_at(time: DualNumber(3, 1)).dual).to be_roughly Math::E ** 3 }
    end

    describe 'natural logarithm' do
      def position_at(time:)
        Math.log(time)
      end

      specify { expect(position_at(time: Math::E ** 0)).to be_roughly 0 }
      specify { expect(position_at(time: Math::E ** 1)).to be_roughly 1 }
      specify { expect(position_at(time: Math::E ** 2)).to be_roughly 2 }
      specify { expect(position_at(time: Math::E ** 3)).to be_roughly 3 }

      specify { expect(position_at(time: DualNumber(Math::E ** 0, 1)).real).to be_roughly 0 }
      specify { expect(position_at(time: DualNumber(Math::E ** 1, 1)).real).to be_roughly 1 }
      specify { expect(position_at(time: DualNumber(Math::E ** 2, 1)).real).to be_roughly 2 }
      specify { expect(position_at(time: DualNumber(Math::E ** 3, 1)).real).to be_roughly 3 }

      specify { expect(position_at(time: DualNumber(Math::E ** 0, 1)).dual).to be_roughly Math::E ** 0 }
      specify { expect(position_at(time: DualNumber(Math::E ** 1, 1)).dual).to be_roughly Math::E ** -1 }
      specify { expect(position_at(time: DualNumber(Math::E ** 2, 1)).dual).to be_roughly Math::E ** -2 }
      specify { expect(position_at(time: DualNumber(Math::E ** 3, 1)).dual).to be_roughly Math::E ** -3 }
    end

    describe 'square root' do
      def position_at(time:)
        Math.sqrt(time)
      end

      specify { expect(position_at(time: 0 ** 2)).to be_roughly 0 }
      specify { expect(position_at(time: 1 ** 2)).to be_roughly 1 }
      specify { expect(position_at(time: 2 ** 2)).to be_roughly 2 }
      specify { expect(position_at(time: 3 ** 2)).to be_roughly 3 }

      specify { expect(position_at(time: DualNumber(0 ** 2, 1)).real).to be_roughly 0 }
      specify { expect(position_at(time: DualNumber(1 ** 2, 1)).real).to be_roughly 1 }
      specify { expect(position_at(time: DualNumber(2 ** 2, 1)).real).to be_roughly 2 }
      specify { expect(position_at(time: DualNumber(3 ** 2, 1)).real).to be_roughly 3 }

      specify { expect(position_at(time: DualNumber(0 ** 2, 1)).dual).to eq 1.0 / 0 }
      specify { expect(position_at(time: DualNumber(1 ** 2, 1)).dual).to be_roughly 1.0 / 2 }
      specify { expect(position_at(time: DualNumber(2 ** 2, 1)).dual).to be_roughly 1.0 / 4 }
      specify { expect(position_at(time: DualNumber(3 ** 2, 1)).dual).to be_roughly 1.0 / 6 }
    end
  end
end
