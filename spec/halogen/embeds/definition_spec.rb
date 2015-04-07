# encoding: utf-8
#
require 'spec_helper'

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
end
