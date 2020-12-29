require_relative '/Users/oliversanford/json_benchmarks/halogen/lib/halogen2'

describe Halogen2::Configuration do
  describe '#extensions' do
    it 'is empty array by default' do
      expect(Halogen2::Configuration.new.extensions).to eq([])
    end
  end
end
