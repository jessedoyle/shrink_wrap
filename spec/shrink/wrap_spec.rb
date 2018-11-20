# frozen_string_literal: true

describe Shrink::Wrap do
  describe '#shrink_wrap' do
    let(:raw) { JSON.parse(read_fixture('versions.json')) }

    it 'shrink wraps JSON data' do
      instance = ModelStubs::Base.shrink_wrap(raw)
      expect(instance.name).to eq('Base')
      expect(instance.versions).to be_an(Array)
      expect(instance.versions.first).to be_a(ModelStubs::Version)
    end
  end

  describe '#translate_all' do
    let(:data) { { 'one' => 1, 'two' => 2 } }

    it 'passes the data hash to the instance initialization' do
      instance = ModelStubs::TranslateAll.shrink_wrap(data)
      expect(instance.data).to eq(one: 1, two: 2)
    end
  end
end
