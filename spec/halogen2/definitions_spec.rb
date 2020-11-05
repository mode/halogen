require_relative '../../lib/halogen2'

describe Halogen2::Definitions do
  let :definitions do
    Halogen2::Definitions.new
  end

  let :definition do
    Halogen2::Definition.new(:name, {}, nil)
  end

  describe '#add' do
    it 'validates and adds definition' do
      expect(definitions.keys).to eq([])

      definitions.add(definition)

      expect(definitions.keys).to eq(['Halogen2::Definition'])
      expect(definitions['Halogen2::Definition']).to eq([definition])
    end
  end
end
