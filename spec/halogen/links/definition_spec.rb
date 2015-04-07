# encoding: utf-8
#
require 'spec_helper'

describe Halogen::Links::Definition do
  describe '#validate' do
    it 'returns true with procedure' do
      result = Halogen::Links::Definition.new(:name, proc {}).validate

      expect(result).to eq(true)
    end

    it 'raises exception without procedure or explicit value' do
      expect {
        Halogen::Links::Definition.new(:name, nil).validate
      }.to raise_error do |exception|
        expect(exception).to be_an_instance_of(Halogen::InvalidDefinition)
        expect(exception.message).to(
          eq('Link requires either procedure or explicit value'))
      end
    end
  end

  describe '.build_options' do
    it 'has expected value without options hash' do
      options = Halogen::Links::Definition.build_options([])

      expect(options).to eq(attrs: {})
    end

    it 'has expected value with options hash' do
      options = Halogen::Links::Definition.build_options([foo: 'bar'])

      expect(options).to eq(attrs: {}, foo: 'bar')
    end

    it 'merges attrs from options' do
      options = Halogen::Links::Definition.build_options([
        :templated,
        attrs: { properties: {} },
        foo: 'bar'])

      expect(options).to(
        eq(attrs: { properties: {}, templated: true }, foo: 'bar'))
    end
  end

  describe '.build_attrs' do
    it 'returns empty hash if no keywords are provided' do
      expect(Halogen::Links::Definition.build_attrs([])).to eq({})
    end

    it 'builds expected hash with recognized keywords' do
      attrs = Halogen::Links::Definition.build_attrs([:templated])

      expect(attrs).to eq(templated: true)
    end

    it 'raises exception if unrecognized keyword is included' do
      expect {
        Halogen::Links::Definition.build_attrs([:templated, :wat])
      }.to raise_error do |exception|
        expect(exception.class).to eq(Halogen::InvalidDefinition)
        expect(exception.message).to eq('Unrecognized link keyword: wat')
      end
    end
  end
end
