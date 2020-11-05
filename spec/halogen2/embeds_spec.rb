require_relative '../../lib/halogen2'

describe Halogen2::Embeds do
  let :klass do
    Class.new do
      include Halogen2
      include Halogen2::Embeds
    end
  end

  describe Halogen2::Embeds::ClassMethods do
    it 'adds simple embed definition' do
      expect(klass.definitions).to receive(:add)

      klass.embed(:foo, {}) { 'bar' }
    end
  end

  describe Halogen2::Embeds::InstanceMethods do
    describe '#embedded' do
      describe 'when no embeds are defined' do
        it 'returns empty hash when no embeds are requested' do
          representer = klass.new

          expect(representer.embedded).to eq({})
        end

        it 'returns empty hash when embeds are requested' do
          representer = klass.new(embed: { foo: true })

          expect(representer.embedded).to eq({})
        end
      end

      describe 'when embeds are defined' do
        before :each do
          klass.embed(:just_nil, {}) { nil }
          klass.embed(:non_repr, {}) { 'some object' }
          klass.embed(:child_repr, {}) { child }

          klass.send(:define_method, :child) do
            # just build another representer instance to be rendered
            Class.new { include Halogen }.new
          end
        end

        it 'returns empty hash when no embeds are requested' do
          representer = klass.new(embed: {})

          expect(representer.embedded).to eq({})
        end

        it 'builds embedded resources as expected' do
          embed_opts = { just_nil: true, non_repr: true, child_repr: true }

          representer = klass.new(embed: embed_opts)

          expect(representer.embedded).to eq(child_repr: {})
        end
      end
    end

    describe '#embedded_child' do
      let :representer do
        klass.new
      end

      let :child_class do
        Class.new do
          include Halogen2

          property(:foo) { 'bar' }
        end
      end

      let :child do
        child_class.new
      end

      it 'returns nil if value is falsey' do
        [nil, false, 0].each do |value|
          expect(representer.embedded_child(:foo, value)).to be_nil
        end
      end

      describe 'when value is an array' do
        it 'renders children' do
          array = [child, nil, 0, child, 1]

          result = representer.embedded_child(:embed_key, array)

          expect(result).to eq([{ foo: 'bar' }, { foo: 'bar' }])
        end
      end

      describe 'when value is a representer' do
        it 'renders child' do
          result = representer.embedded_child(:embed_key, child)

          expect(result).to eq(foo: 'bar')
        end
      end
    end

    describe '#child_embed_opts' do
      it 'returns empty options for unknown key' do
        representer = klass.new

        opts = representer.send(:child_embed_opts, :unknown_key)

        expect(opts).to eq({})
      end

      it 'returns empty options for known key with no child options' do
        representer = klass.new(embed: { requested_key: 1 })

        opts = representer.send(:child_embed_opts, 'requested_key')

        expect(opts).to eq({})
      end

      it 'returns child options for known key with child options' do
        representer = klass.new(embed: { requested_key: { child_key: 0 } })

        opts = representer.send(:child_embed_opts, 'requested_key')

        expect(opts).to eq(child_key: 0)
      end

      it 'returns deeply nested child options' do
        representer = klass.new(
          embed: {
            requested_key: {
              child_key: { grandchild_key: { great_grandchild_key: 1 } }
            }
          }
        )

        opts = representer.send(:child_embed_opts, 'requested_key')

        expect(opts).to eq(
          child_key: { grandchild_key: { great_grandchild_key: 1 } })
      end
    end

    describe '#render_child' do
      let :representer do
        Class.new do
          include Halogen2

          property(:verify_parent) { parent.object_id }
          property(:verify_opts)   { options[:embed] }
        end.new
      end

      it 'returns nil if child is not a representer' do
        [nil, 1, ''].each do |child|
          expect(klass.new.render_child(child, {})).to be_nil
        end
      end

      it 'renders child representer with correct parent and options' do
        result = representer.render_child(representer, foo: 'bar')

        expect(result).to eq(
          verify_parent: representer.object_id,
          verify_opts: { foo: 'bar' })
      end

      it 'merges child options if already present' do
        representer.options[:embed] = { bar: 'bar' }

        result = representer.render_child(representer, foo: 'foo')

        expect(result[:verify_opts]).to eq(foo: 'foo', bar: 'bar')
      end
    end

    describe '#embed_options' do
      it 'stringifies top level keys' do
        representer = klass.new(embed: { some: { options: 1 } })

        expect(representer.embed_options).to eq('some' => { options: 1 })
      end
    end
  end
end
