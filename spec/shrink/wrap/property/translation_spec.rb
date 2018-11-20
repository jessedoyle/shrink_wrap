# frozen_string_literal: true

describe Shrink::Wrap::Property::Translation do
  let(:params) { { allow_nil: allow_nil, default: default, from: from } }
  subject { described_class.new(params) }

  describe '#translate' do
    let(:from) { :key }

    context 'with an invalid value as input' do
      let(:allow_nil) { false }
      let(:default) { nil }
      let(:input) { :invalid }

      it 'raises ArgumentError' do
        expect { subject.translate(input) }.to raise_error(
          ArgumentError,
          'expected Hash, got: :invalid'
        )
      end
    end

    context 'with a Hash as input' do
      context 'when the key is nil' do
        let(:allow_nil) { false }
        let(:input) { { test: true } }

        context 'with allow_nil == true' do
          let(:allow_nil) { true }
          let(:default) { false }

          it 'returns nil' do
            expect(subject.translate(input)).to be_nil
          end
        end

        context 'without a default set' do
          let(:default) { nil }

          it 'raises KeyError' do
            expect { subject.translate(input) }.to raise_error(
              KeyError,
              /Key not found `:key`/
            )
          end
        end

        context 'with a default set' do
          context 'when the default is not callable' do
            let(:default) { :invalid }

            it 'raises ArgumentError' do
              expect { subject.translate(input) }.to raise_error(
                ArgumentError,
                'expected callable, got: :invalid'
              )
            end
          end

          context 'when the default is callable' do
            let(:default) { -> { Date.today } }

            it 'returns the default value' do
              expect(subject.translate(input)).to eq(default.call)
            end
          end
        end
      end
    end
  end
end
