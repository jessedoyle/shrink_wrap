# frozen_string_literal: true

describe Shrink::Wrap::Property::Coercion do
  describe '#initialize' do
    subject { described_class.new(param) }

    context 'with a Class' do
      let(:param) { Regexp }

      it 'sets the base attribute to a Coercion::Class instance' do
        expect(subject.base).to be_a(Shrink::Wrap::Property::Coercion::Class)
      end
    end

    context 'with a Enumerable' do
      let(:param) { [Regexp] }

      it 'sets the base attribute to a Coercion::Enumerable instance' do
        expect(subject.base).to be_a(
          Shrink::Wrap::Property::Coercion::Enumerable
        )
      end
    end

    context 'with a Proc' do
      let(:param) { ->(v) { v.to_sym } }

      it 'sets the base attribute to a Coercion::Proc instance' do
        expect(subject.base).to be_a(Shrink::Wrap::Property::Coercion::Proc)
      end
    end

    context 'with an invalid parameter' do
      let(:param) { :invalid }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(
          ArgumentError,
          'expected Class, Enumerable or Proc, got: :invalid'
        )
      end
    end
  end
end
