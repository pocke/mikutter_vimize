require_relative '../spec_helper'

describe Vimizer do
  let(:slug){:vimizer}
  let(:instance){Vimizer.new(slug)}
  let(:key){Vimizer::Key.new('h', ctrl: true)}

  describe '.new' do
    subject{instance}

    it 'should return Vimizer instance' do
      expect(subject).to be_a Vimizer
    end
  end

  describe '#define' do
    let(:mode){:i}
    subject{instance.define(key, mode){|vimizer, opt|}}

    context 'invalid mode' do
      let(:mode){:q}

      it do
        expect{subject}.to raise_error Vimizer::InvalidMode
      end
    end

    context 'valid mode' do
      it 'should define command' do
        expect_any_instance_of(Plugin).to receive(:command)
        subject
      end

      it 'should return Hash' do
        expect(subject).to be_a Hash
      end
    end
  end
end
