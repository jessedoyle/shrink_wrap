# frozen_string_literal: true

describe Shrink::Wrap::Transformer::Base do
  describe '#transform' do
    it 'raises NotImplementedError' do
      expect { subject.transform({}) }.to raise_error(NotImplementedError)
    end
  end
end
