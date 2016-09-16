require 'spec_helper'

describe Halogen::Configuration do
  describe '#extensions' do
    it 'is empty array by default' do
      expect(Halogen::Configuration.new.extensions).to eq([])
    end
  end
end
