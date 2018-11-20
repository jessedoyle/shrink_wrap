# frozen_string_literal: true

describe Shrink::Wrap::Transformer::Symbolize do
  let(:nested_hash) do
    {
      'input' => {
        'foo' => {
          'bar' => true
        },
        'baz' => 'test'
      }
    }
  end
  let(:nested_array) { Array.new(3) { nested_hash } }
  subject { described_class.new(depth: depth) }

  describe '#transform' do
    context 'with a depth of 1' do
      let(:depth) { 1 }

      context 'with a nested hash' do
        it 'symbolizes the hash to a depth of 1' do
          expect(subject.transform(nested_hash)).to eq(
            input: {
              'foo' => {
                'bar' => true
              },
              'baz' => 'test'
            }
          )
        end
      end

      context 'with an array of objects' do
        let(:transformed) { subject.transform(nested_array) }

        it 'returns an array' do
          expect(transformed).to be_an(Array)
        end

        it 'retains the array size' do
          expect(transformed.length).to eq(nested_array.length)
        end

        it 'symbolizes each array element to a depth of 1' do
          transformed.each do |element|
            expect(element).to eq(
              input: {
                'foo' => {
                  'bar' => true
                },
                'baz' => 'test'
              }
            )
          end
        end
      end

      context 'with an empty array' do
        it 'returns an empty array' do
          expect(subject.transform([])).to eq([])
        end
      end

      context 'with nil' do
        it 'returns nil' do
          expect(subject.transform(nil)).to be_nil
        end
      end
    end

    context 'with a depth of Float::INFINITY' do
      let(:depth) { Float::INFINITY }

      context 'with a nested hash' do
        it 'fully symbolizes the hash' do
          expect(subject.transform(nested_hash)).to eq(
            input: {
              foo: {
                bar: true
              },
              baz: 'test'
            }
          )
        end
      end

      context 'with an array of objects' do
        it 'symbolizes each of the array elements' do
          subject.transform(nested_array).each do |element|
            expect(element).to eq(
              input: {
                foo: {
                  bar: true
                },
                baz: 'test'
              }
            )
          end
        end
      end

      context 'with an empty array' do
        it 'returns an empty array' do
          expect(subject.transform([])).to eq([])
        end
      end

      context 'with nil' do
        it 'returns nil' do
          expect(subject.transform(nil)).to eq(nil)
        end
      end
    end
  end
end
