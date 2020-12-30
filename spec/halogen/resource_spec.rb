require '/Users/oliversanford/json_benchmarks/halogen/lib/halogen'

describe Halogen::Resource do
  let :klass do
    Class.new do
      include Halogen
      include Halogen::Resource
    end
  end

  describe '.included' do
    it 'raises error if base is already a collection' do
      resource_class = Class.new do
        include Halogen
        include Halogen::Collection
      end

      expect {
        resource_class.send :include, Halogen::Resource
      }.to raise_error do |exception|
        expect(exception).to be_an_instance_of(Halogen::InvalidResource)
        expect(exception.message).to match(/has already defined a collection/i)
      end
    end
  end

  describe Halogen::Resource::ClassMethods do
    describe '#define_resource' do
      it 'defines resource' do
        klass.define_resource :foo

        expect(klass.resource_name).to eq('foo')
        expect(klass.respond_to?(:foo)).to eq(true)
      end
    end

    describe '#property' do
      it 'returns result of super if procedure is present' do
        original = proc { 'bar' }

        definition = klass.property(:foo, &original)

        expect(definition.procedure).to eq(original)
      end

      it 'returns result of super if value is present' do
        definition = klass.property(:foo, value: 'bar')

        expect(definition.procedure).to be_nil
      end

      it 'assigns procedure without original procedure or value' do
        definition = klass.property(:foo)

        expect(definition.procedure).to be_an_instance_of(Proc)
      end
    end
  end

  describe Halogen::Resource::ClassMethods do
    describe '.render' do
      it 'raises error if resource is not provided' do
        expect { klass.render }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#collection?' do
    it 'is false' do
      expect(klass.collection?).to eq(false)
    end
  end
end
