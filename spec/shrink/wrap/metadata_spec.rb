# frozen_string_literal: true

describe Shrink::Wrap::Metadata do
  describe '#transform' do
    let(:input) { { 'test' => true } }

    before(:each) do
      subject.add_transformer(Shrink::Wrap::Transformer::Symbolize)
    end

    it 'transforms the input' do
      expect(subject.transform(input)).to eq(test: true)
    end
  end

  describe '#translate' do
    context 'with translations specified' do
      let(:input) { { Test: true } }

      before(:each) do
        subject.add_translation(:test, from: :Test)
      end

      it 'translates the input' do
        expect(subject.translate(input)).to eq(test: true)
      end
    end

    context 'without translations specified' do
      let(:input) { { test: true } }

      it 'returns an empty hash' do
        expect(subject.translate(input)).to eq({})
      end
    end

    context 'with translate_all specified' do
      let(:input) { { one: 1, two: 2 } }

      before(:each) do
        subject.translate_all!
      end

      it 'returns the entire input hash' do
        expect(subject.transform(input)).to eq(input)
      end
    end
  end

  describe 'coerce' do
    context 'with numbers' do
      let(:input) { { number: 1 } }

      before(:each) do
        subject.add_coercion(:number, ->(v) { v + 1 })
      end

      it 'coerces the input' do
        expect(subject.coerce(input)).to eq(number: 2)
      end
    end

    context 'when coercing strings to boolean' do
      let(:input) { { boolean: 'false' } }

      before(:each) do
        subject.add_coercion(:boolean, ->(v) { v.to_s.casecmp('true').zero? })
      end

      it 'returns the coerced boolean value' do
        expect(subject.coerce(input)).to eq(boolean: false)
      end
    end
  end
end
