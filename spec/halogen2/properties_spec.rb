require_relative '/Users/oliversanford/json_benchmarks/halogen/lib/halogen2'

describe Halogen2::Properties do
  let :klass do
    Class.new { include Halogen2 }
  end

  describe Halogen2::Properties::ClassMethods do
    describe '#property' do
      it 'defines property' do
        expect {
          klass.property(:foo)
        }.to change(klass.definitions, :size).by(1)
      end
    end

    describe '#render' do
      it 'merges super with rendered properties' do
        klass.property(:foo)

        expect(klass.render(foo: 'bar')).to eq(foo: 'bar')
      end
    end

    describe '#properties' do
      it 'builds properties from definitions' do
        klass.property(:foo, value: 'bar')

        expect(repr.properties).to eq(foo: 'bar')
      end
    end
  end
end
