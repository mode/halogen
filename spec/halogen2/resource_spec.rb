require '/Users/oliversanford/json_benchmarks/halogen/lib/halogen2'

describe Halogen2::Resource do
  let :klass do
    Class.new do
      include Halogen2
      include Halogen2::Resource
    end
  end

  describe '.included' do
    it 'raises error if base is already a collection' do
      resource_class = Class.new do
        include Halogen2
        include Halogen2::Collection
      end

      expect {
        resource_class.send :include, Halogen2::Resource
      }.to raise_error do |exception|
        expect(exception).to be_an_instance_of(Halogen2::InvalidResource)
        expect(exception.message).to match(/has already defined a collection/i)
      end
    end
  end

  describe Halogen2::Resource::ClassMethods do
    describe '#define_resource' do
      it 'defines resource' do
        klass.define_resource :foo

        expect(klass.resource_name).to eq('foo')
        expect(klass.new(nil).respond_to?(:foo)).to eq(true)
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

  describe Halogen2::Resource::ClassMethods do
    describe '.render' do
      it 'raises error if resource is not provided' do
        expect { klass.render }.to raise_error(ArgumentError)
      end

      it 'assigns resource' do
        resource = double(:resource)

        repr = klass.new(resource)

        expect(repr.instance_variable_get(:@resource)).to eq(resource)
      end
    end
  end

  describe '#collection?' do
    it 'is false' do
      repr = klass.new(nil)

      expect(repr.collection?).to eq(false)
    end
  end
end
