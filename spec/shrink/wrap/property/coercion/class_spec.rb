# frozen_string_literal: true

describe Shrink::Wrap::Property::Coercion::Class do
  subject { described_class.new(klass) }

  describe '#initialize' do
    context 'when a a valid class name is not provided' do
      let(:klass) { 'test' }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(
          ArgumentError,
          'expected Class, got: "test"'
        )
      end
    end
  end

  describe '#coerce' do
    context 'when the class responds to shrink_wrap' do
      let(:klass) { ModelStubs::Version }
      let(:input) { { version: '2018-01-01' } }

      it 'calls shrink_wrap with the data' do
        expect(subject.coerce(input)).to eq(klass.shrink_wrap(input))
      end
    end

    context 'when the class responds to coerce' do
      let(:klass) { ModelStubs::Coerce }
      let(:input) { { test: 'true' } }

      it 'calls coerce with the data' do
        expect(subject.coerce(input)).to eq(klass.coerce(input))
      end
    end

    context 'when the class does not respond to coerce or shrink_wrap' do
      let(:klass) { Regexp }
      let(:input) { 'regexp' }

      it 'creates a new instance with the data' do
        expect(subject.coerce(input)).to eq(klass.new(input))
      end
    end
  end
end
