# encoding: utf-8
#
require 'spec_helper'

describe Halogen::Collection do
  let :klass do
    Class.new do
      include Halogen
      include Halogen::Collection
    end
  end

  describe '.included' do
    it 'raises error if base is already a resource' do
      resource_class = Class.new do
        include Halogen
        include Halogen::Resource
      end

      expect {
        resource_class.send :include, Halogen::Collection
      }.to raise_error do |exception|
        expect(exception).to be_an_instance_of(Halogen::InvalidCollection)
        expect(exception.message).to match(/has already defined a resource/i)
      end
    end
  end

  describe Halogen::Collection::ClassMethods do
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

  describe Halogen::Collection::InstanceMethods do
    describe '#embed?' do
      it 'returns true if super is true' do
        klass.collection_name = 'bar'

        klass.embed(:foo) { klass.new }

        repr = klass.new(embed: { foo: 1 })

        expect(repr.embed?('foo')).to eq(true)
      end

      it 'returns true if key matches collection name' do
        klass.collection_name = 'foo'

        klass.embed(:foo) { klass.new }

        repr = klass.new(embed: { foo: 0 })

        expect(repr.embed?('foo')).to eq(true)
      end

      it 'returns false if no conditions match' do
        klass.collection_name = 'bar'

        klass.embed(:foo) { klass.new }

        repr = klass.new(embed: { foo: 0 })

        expect(repr.embed?('foo')).to eq(false)
      end
    end
  end
end
