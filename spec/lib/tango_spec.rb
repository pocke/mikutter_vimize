require_relative '../spec_helper'

describe Tango do
  describe '.get_index' do
    subject{Tango.get_index(text, index)}
    [
      ['hoge fuga',    1, [0, 3]],
      ['hoge fuga',    6, [5, 8]],
      ['hoge fuga',    4, [4, 4]],
      ['hoge-fuga',    4, [4, 4]],
      ['hoge-fuga',    1, [0, 3]],
      ['hoge_fuga',    1, [0, 8]],
      ['hoge_fuga',    4, [0, 8]],
      ['hoge7fuga',    1, [0, 8]],
      ['hoge7fuga',    4, [0, 8]],
      ['ほげ ふが',    1, [0, 1]],
      ['ほげ ふが',    2, [2, 2]],
      ['ほげフガ猫犬', 1, [0, 1]],
      ['ほげフガ猫犬', 2, [2, 3]],
      ['ほげフガ猫犬', 4, [4, 5]],
    ].each do |t, i, result|
      context "text: '#{t}, index: #{i}'" do
        let(:text){t}
        let(:index){i}

        it{is_expected.to eq result}
      end
    end
  end
end
