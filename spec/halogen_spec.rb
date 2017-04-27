describe Halogen do
  let :klass do
    Class.new { include Halogen }
  end

  describe Halogen::ClassMethods do
    describe '#resource' do
      it 'includes resource module' do
        klass = Class.new { include Halogen }

        expect(klass).to receive(:define_resource)

        klass.resource :foo

        expect(klass.included_modules.include?(Halogen::Resource)).to eq(true)
      end
    end

    describe '#collection' do
      it 'includes collection module' do
        klass = Class.new { include Halogen }

        expect(klass).to receive(:define_collection)

        klass.collection :foo

        expect(klass.included_modules.include?(Halogen::Collection)).to eq(true)
      end
    end

    describe '#collection?' do
      it 'is false by default' do
        klass = Class.new { include Halogen }

        expect(klass.collection?).to eq(false)
      end

      it 'is true for collection' do
        klass = Class.new { include Halogen }

        klass.collection :foo

        expect(klass.collection?).to eq(true)
      end
    end
  end

  describe Halogen::InstanceMethods do
    describe '#initialize' do
      it 'symbolizes option keys' do
        repr = klass.new(
          'embed'  => { 'foo' => 'bar' },
          'ignore' => 'this',
          :convert => 'that')

        expect(repr.options).to eq(
          embed:   { 'foo' => 'bar' },
          ignore:  'this',
          convert: 'that'
        )
      end
    end

    describe '#render' do
      let :rendered do
        klass.new.render
      end

      it 'renders simple link' do
        klass.link(:label) { 'href' }

        expect(rendered[:_links][:label]).to eq(href: 'href')
      end

      it 'does not include link if conditional checks fail' do
        klass.send(:define_method, :return_false) { false }
        klass.send(:define_method, :return_nil)   { nil }

        klass.link(:label) { 'href' }

        klass.link(:label_2, if: false)          { 'href' }
        klass.link(:label_3, if: proc { false }) { 'href' }
        klass.link(:label_4, if: proc { nil })   { 'href' }
        klass.link(:label_5, if: :return_false)  { 'href' }

        expect(rendered[:_links].keys).to eq([:label])
      end

      it 'includes link if conditional checks pass' do
        klass.send(:define_method, :return_true) { true }
        klass.send(:define_method, :return_one)  { 1 }

        klass.link(:label) { 'href' }

        klass.link(:label_2, if: true)          { 'href' }
        klass.link(:label_3, if: proc { true }) { 'href' }
        klass.link(:label_4, if: proc { 1 })    { 'href' }
        klass.link(:label_5, if: :return_true)  { 'href' }

        expected = [:label, :label_2, :label_3, :label_4, :label_5]
        expect(rendered[:_links].keys).to eq(expected)
      end
    end

    describe '#depth' do
      it 'is zero for top level representer' do
        expect(klass.new.depth).to eq(0)
      end

      it 'has expected value for embedded children' do
        parent = klass.new

        child = klass.new
        allow(child).to receive(:parent).and_return(parent)

        grandchild = klass.new
        allow(grandchild).to receive(:parent).and_return(child)

        expect(parent.depth).to eq(0)
        expect(child.depth).to eq(1)
        expect(grandchild.depth).to eq(2)
      end
    end

    describe '#to_json' do
      it 'converts rendered representer to json' do
        expect(klass.new.to_json).to eq('{}')
      end
    end
  end

  describe '.config' do
    it 'yields configuration instance' do
      Halogen.configure do |config|
        expect(config).to eq(Halogen.config)
      end
    end
  end
end
