describe Halogen::Definitions do
  let :definitions do
    Halogen::Definitions.new
  end

  let :definition do
    Halogen::Definition.new(:name, {}, nil)
  end

  describe '#add' do
    it 'validates and adds definition' do
      expect(definitions.keys).to eq([])

      definitions.add(definition)

      expect(definitions.keys).to eq(['Halogen::Definition'])
      expect(definitions['Halogen::Definition']).to eq([definition])
    end
  end
end
