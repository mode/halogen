require 'spec_helper'

describe Halogen::Properties do
  let :klass do
    Class.new { include Halogen }
  end

  describe Halogen::Properties::ClassMethods do
    describe '#property' do
      it 'defines property 'do
        expect {
          klass.property(:foo)
        }.to change(klass.definitions, :size).by(1)
      end
    end
  end

  describe Halogen::Properties::InstanceMethods do
    let :repr do
      klass.new
    end

    describe '#render' do
      it 'merges super with rendered properties' do
        allow(repr).to receive(:properties).and_return(foo: 'bar')

        expect(repr.render).to eq(foo: 'bar')
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
