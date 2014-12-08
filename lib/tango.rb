module Tango
  module_function

  # text の index の位置にある単語の始点と終点を返す。
  # ==== Args
  # [text] String 単語を探す対象の文章
  # [index] Integer
  # ==== Return
  # Array
  # [first, last]
  def get_index(text, index)
    # XXX: Vimの挙動もそうなんだけど、長音符が単語区切りにされちゃうよね
    anti_pat = case text[index]
      when /[0-9a-zA-Z_]/
        /[^0-9a-zA-Z_]/
      when /[\p{Hiragana}]/
        /[\p{^Hiragana}]/
      when /[\p{Katakana}]/
        /[\p{^Katakana}]/
      when /[\p{Han}]/
        /[\p{^Han}]/
      else
        /[0-9a-zA-Z_\p{Hiragana}\p{Katakana}\p{Han}]/
      end

    first = text.rindex(anti_pat, index) || -1
    first += 1

    last = text.index(anti_pat, index) || text.size
    last -= 1

    return [first, last]
  end
end
