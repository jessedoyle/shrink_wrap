# frozen_string_literal: true

describe Shrink::Wrap::Transformer::CollectionFromKey do
  describe '#initialize' do
    context 'with invalid arguments' do
      it 'raises ArgumentError' do
        expect { described_class.new(nil) }.to raise_error(
          ArgumentError,
          'options must contain one key/value pair'
        )
      end
    end
  end

  describe '#transform' do
    subject { described_class.new(names: :name) }

    context 'with nil input' do
      it 'raises ArgumentError' do
        expect { subject.transform(nil) }.to raise_error(
          ArgumentError,
          'expected Hash, got: nil'
        )
      end
    end

    context 'with a Hash input' do
      context 'when the from key is not present' do
        let(:hash) do
          {
            data: {
              test: true
            }
          }
        end

        it 'returns the input hash' do
          expect(subject.transform(hash)).to eq(hash)
        end
      end

      context 'when the from key is present' do
        context 'when the from value is not a Hash' do
          let(:hash) { { names: true } }

          it 'returns the input hash' do
            expect(subject.transform(hash)).to eq(hash)
          end
        end

        context 'when the from value is a hash' do
          context 'when the child elements are not hashes' do
            let(:hash) { { names: { a: 1, b: 2 } } }

            it 'raises ArgumentError' do
              expect { subject.transform(hash) }.to raise_error(
                ArgumentError,
                'expected Hash, got: 1'
              )
            end
          end

          context 'when the child elements are hashes' do
            let(:hash) do
              {
                names: {
                  sunday: {
                    index: 0
                  },
                  monday: {
                    index: 1
                  }
                }
              }
            end

            it 'returns an array with the key as an attribute' do
              expect(subject.transform(hash)).to eq(
                names: [
                  {
                    name: :sunday,
                    index: 0
                  },
                  {
                    name: :monday,
                    index: 1
                  }
                ]
              )
            end
          end
        end
      end
    end
  end
end
