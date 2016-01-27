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
end
