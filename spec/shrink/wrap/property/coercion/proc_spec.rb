# frozen_string_literal: true

describe Shrink::Wrap::Property::Coercion::Proc do
  subject { described_class.new(callable) }

  describe '#initialize' do
    context 'with an invalid callable argument' do
      let(:callable) { :invalid }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(
          ArgumentError,
          'expected callable, got: :invalid'
        )
      end
    end

    context 'with a callable argument that does not have arity of 1' do
      let(:callable) { ->(a, b) { a + b } }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(
          ArgumentError,
          'expected callable with arity of 1'
        )
      end
    end
  end

  describe '#coerce' do
    let(:callable) { ->(a) { a + 1 } }
    let(:input) { 1 }

    it 'calls the proc with the input data' do
      expect(subject.coerce(input)).to eq(2)
    end
  end
end
