require_relative '../../spec_helper'

describe Vimizer::Key do
  let(:main_key){'h'}
  let(:modifyer_keys){{}}
  let(:instance){Vimizer::Key.new(main_key, modifyer_keys)}

  describe '.new' do
    subject{instance}

    it{is_expected.to be_a Vimizer::Key}
  end

  describe '#to_slug' do
    subject{instance.to_slug}

    context 'when not have modifyer key' do
      it{is_expected.to eq :H}
    end

    context 'when ctrl on' do
      let(:modifyer_keys){{ctrl: true}}

      it{is_expected.to eq :CTRL_H}
    end

    context 'when meta on' do
      let(:modifyer_keys){{meta: true}}

      it{is_expected.to eq :META_H}
    end

    context 'when shift on' do
      let(:modifyer_keys){{shift: true}}

      it{is_expected.to eq :SHIFT_H}
    end

    context 'when ctrl, shift and meta on' do
      let(:modifyer_keys){{meta: true, ctrl: true, shift: true}}

      it{is_expected.to eq :CTRL_SHIFT_META_H}
    end
  end

  describe '#to_name' do
    subject{instance.to_name}

    context 'when not have modifyer key' do
      it{is_expected.to eq :h}
    end

    context 'when ctrl on' do
      let(:modifyer_keys){{ctrl: true}}

      it{is_expected.to eq :"<C-h>"}
    end

    context 'when meta on' do
      let(:modifyer_keys){{meta: true}}

      it{is_expected.to eq :"<M-h>"}
    end

    context 'when shift on' do
      let(:modifyer_keys){{shift: true}}

      it{is_expected.to eq :"<S-h>"}
    end

    context 'when ctrl, shift and meta on' do
      let(:modifyer_keys){{meta: true, ctrl: true, shift: true}}

      it{is_expected.to eq :"<C-S-M-h>"}
    end
  end

  describe '#to_config' do
    subject{instance.to_config}

    context 'when not have modifyer key' do
      it{is_expected.to eq 'h'}
    end

    context 'when ctrl on' do
      let(:modifyer_keys){{ctrl: true}}

      it{is_expected.to eq "Control + h"}
    end

    context 'when meta on' do
      let(:modifyer_keys){{meta: true}}

      it{is_expected.to eq "Alt + h"}
    end

    context 'when shift on' do
      let(:modifyer_keys){{shift: true}}

      it{is_expected.to eq "Shift + h"}
    end

    context 'when ctrl, shift and meta on' do
      let(:modifyer_keys){{meta: true, ctrl: true, shift: true}}

      it{is_expected.to eq "Control + Shift + Alt + h"}
    end
  end
end
