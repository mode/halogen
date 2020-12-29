require '/Users/oliversanford/json_benchmarks/halogen/lib/halogen2'

describe Halogen2::Collection do
  let :klass do
    Class.new do
      include Halogen2
      include Halogen2::Collection
    end
  end

  describe '.included' do
    it 'raises error if base is already a resource' do
      resource_class = Class.new do
        include Halogen2
        include Halogen2::Resource
      end

      expect {
        resource_class.send :include, Halogen2::Collection
      }.to raise_error do |exception|
        expect(exception).to be_an_instance_of(Halogen2::InvalidCollection)
        expect(exception.message).to match(/has already defined a resource/i)
      end
    end
  end

  describe Halogen2::Collection::ClassMethods do
    describe '#define_collection' do
      it 'handles string argument' do
        klass.define_collection 'goats'

        expect(klass.collection_name).to eq('goats')
      end

      it 'handles symbol argument' do
        klass.define_collection :goats

        expect(klass.collection_name).to eq('goats')
      end
    end
  end

  # describe Halogen2::Collection::InstanceMethods do
  #   describe '#embed?' do
  #     it 'returns true if key matches collection name' do
  #       klass.collection_name = 'foo'
  #
  #       expect(klass.new.embed?('foo')).to eq(true)
  #     end
  #
  #     it 'returns false if key does not match' do
  #       klass.collection_name = 'bar'
  #
  #       expect(klass.new.embed?('foo')).to eq(false)
  #     end
  #   end
  #
  #   describe '#collection?' do
  #     it 'is true' do
  #       repr = klass.new
  #
  #       expect(repr.collection?).to eq(true)
  #     end
  #   end
  # end
end
