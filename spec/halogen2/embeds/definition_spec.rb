describe Halogen::Embeds::Definition do
  describe '#validate' do
    it 'returns true with procedure' do
      result = Halogen::Embeds::Definition.new(:name, {}, proc {}).validate

      expect(result).to eq(true)
    end

    it 'raises exception without procedure' do
      expect {
        Halogen::Embeds::Definition.new(:name, {}, nil).validate
      }.to raise_error do |exception|
        expect(exception).to be_an_instance_of(Halogen::InvalidDefinition)
        expect(exception.message).to(
          eq('Embed name must be defined with a proc'))
      end
    end
  end

  describe '#enabled?' do
    let :definition do
      Halogen::Embeds::Definition.new(:name, {}, proc {})
    end

    it 'is true if instance rules return true' do
      repr = double(:repr, embed?: true)

      expect(definition.enabled?(repr)).to eq(true)
    end

    it 'is false if instance rules return false' do
      repr = double(:repr, embed?: false)

      expect(definition.enabled?(repr)).to eq(false)
    end
  end

  describe '#embed_via_options?' do
    let :klass do
      Class.new { include Halogen }
    end

    it 'is true for expected values' do
      [1, 2, true, '1', '2', 'true', 'yes'].each do |value|
        repr = klass.new(embed: { foo: value })

        definition = Halogen::Embeds::Definition.new(:foo, {}, proc {})

        expect(definition.send(:embed_via_options?, repr)).to eq(true)
      end
    end

    it 'is false for expected values' do
      [0, false, '0', 'false'].each do |value|
        repr = klass.new(embed: { foo: value })

        definition = Halogen::Embeds::Definition.new(:foo, {}, proc {})

        expect(definition.send(:embed_via_options?, repr)).to eq(false)
      end
    end
  end
end
