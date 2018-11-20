# frozen_string_literal: true

describe Shrink::Wrap::Property::Coercion::Enumerable do
  describe '#initialize' do
    context 'without an Enumerable argument' do
      it 'raises ArgumentError' do
        expect { described_class.new('test') }.to raise_error(
          ArgumentError,
          'expected Enumerable, got: "test"'
        )
      end
    end

    context 'with an Enumerable argument' do
      it 'sets the enumerable attribute to the first element' do
        instance = described_class.new([Regexp, Integer])
        expect(instance.enumerable).to eq([Regexp])
      end
    end
  end

  describe '#coerce' do
    context 'when enumerable is a Hash' do
      subject { described_class.new(Regexp => Regexp) }

      context 'when the input data is a Hash' do
        let(:input) do
          {
            'One' => 'Two',
            'Three' => 'Four'
          }
        end

        it 'coerces the hash keys and values' do
          expect(subject.coerce(input)).to eq(
            /One/ => /Two/,
            /Three/ => /Four/
          )
        end
      end

      context 'when the input data is not a Hash' do
        let(:input) { 'test' }

        it 'raises ArgumentError' do
          expect { subject.coerce(input) }.to raise_error(
            ArgumentError,
            'expected Hash, got: "test"'
          )
        end
      end
    end

    context 'when enumerable is an Array' do
      subject { described_class.new([Regexp]) }

      context 'when the input data is an Array' do
        let(:input) { %w[one two] }

        it 'coerces the input elements' do
          expect(subject.coerce(input)).to eq([/one/, /two/])
        end
      end

      context 'when the input data is not an enumerable' do
        let(:input) { 'string' }

        it 'raises ArgumentError' do
          expect { subject.coerce(input) }.to raise_error(
            ArgumentError,
            'expected Enumerable, got: "string"'
          )
        end
      end
    end
  end
end
