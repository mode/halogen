

describe Halogen::Properties do
  let :klass do
    Class.new { include Halogen }
  end

  let :resource do
    OpenStruct.new(foo: 'bar')
  end

  describe Halogen::Properties::ClassMethods do
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

        expect(klass.render(resource)).to eq(foo: 'bar')
      end
    end

    describe '#properties' do
      it 'builds properties from definitions' do
        klass.property(:foo, value: 'bar')

        expect(klass.properties).to eq(foo: 'bar')
      end
    end
  end
end
