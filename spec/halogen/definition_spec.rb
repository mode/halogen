# encoding: utf-8
#
require 'spec_helper'

describe Halogen::Definition do
  describe '#initialize' do
    it 'symbolizes option keys' do
      definition = Halogen::Definition.new(
        :name, { 'value' => 'some value', 'foo' => 'bar' }, nil)

      expect(definition.options.keys).to eq([:value, :foo])
    end
  end

  describe '#value' do
    it 'returns value from options if present' do
      definition = Halogen::Definition.new(:name, { value: 'some value' }, nil)

      expect(definition.value(nil)).to eq('some value')
    end

    it 'evaluates procedure if value from options is missing' do
      definition = Halogen::Definition.new(:name, {}, proc { size })

      expect(definition.value('foo')).to eq(3)
    end
  end

  describe '#enabled?' do
    it 'is true if definition is not guarded' do
      definition = Halogen::Definition.new(:name, {}, nil)

      expect(definition.enabled?(nil)).to eq(true)
    end

    describe 'when guard is a proc' do
      let :definition do
        Halogen::Definition.new(:name, { if: proc { empty? } }, nil)
      end

      it 'is true if condition passes' do
        expect(definition.enabled?('')).to eq(true)
      end

      it 'is false if condition fails' do
        expect(definition.enabled?('foo')).to eq(false)
      end
    end

    describe 'when guard is a method name' do
      let :definition do
        Halogen::Definition.new(:name, { if: :empty? }, nil)
      end

      it 'is true if condition passes' do
        expect(definition.enabled?('')).to eq(true)
      end

      it 'is false if condition fails' do
        expect(definition.enabled?('foo')).to eq(false)
      end
    end

    describe 'when guard is truthy' do
      it 'is true if condition passes' do
        definition = Halogen::Definition.new(:name, { if: true }, nil)

        expect(definition.enabled?(nil)).to eq(true)
      end

      it 'is false if condition fails' do
        definition = Halogen::Definition.new(:name, { if: false }, nil)

        expect(definition.enabled?(nil)).to eq(false)
      end
    end

    describe 'when guard is negated' do
      let :definition do
        Halogen::Definition.new(:name, { unless: proc { empty? } }, nil)
      end

      it 'is false if condition passes' do
        expect(definition.enabled?('')).to eq(false)
      end
    end
  end

  describe '#validate' do
    it 'returns true for valid definition' do
      definition = Halogen::Definition.new(:name, { value: 'value' }, nil)

      expect(definition.validate).to eq(true)
    end

    it 'raises error for invalid definition' do
      definition = Halogen::Definition.new(
        :name, { value: 'value' }, proc { 'value' })

      expect {
        definition.validate
      }.to raise_error(Halogen::InvalidDefinition) do |exception|
        expect(exception.message).to(
          eq('Cannot specify both value and procedure for name'))
      end
    end
  end
end
