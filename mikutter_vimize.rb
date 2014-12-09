# Copyright 2014, pocke
# Licensed MIT
# http://opensource.org/licenses/mit-license.php

require_relative 'lib/vimize'
require_relative 'lib/tango'


Plugin.create(:vimize){}

v = Vimizer.new(:vimize)

# ----------------------------------- Insert mode

v.define(Vimizer::Key.new('h', ctrl: true), :i) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  buffer = pbox.buffer

  text = buffer.text
  pos = buffer.cursor_position
  text[pos - 1] = '' if pos - 1 >= 0
  buffer.text = text

  pb = Vimizer::PostBox.new(pbox)
  pb.go(pos - 1)
end

v.define(Vimizer::Key.new('Escape'), :i) do |vimizer, opt|
  vimizer.mode = :n
end

v.define(Vimizer::Key.new('w', ctrl: true), :i) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pos = pbox.buffer.cursor_position
  text = pbox.buffer.text
  first, _ = Tango.get_index(text, pos -1)
  text[first..(pos - 1)] = ''

  pbox.buffer.text = text

  pb = Vimizer::PostBox.new(pbox)
  pb.go(first)
end

# ------------------------------------ Normal mode

v.define(Vimizer::Key.new('i'), :n) do |vimizer, opt|
  vimizer.mode = :i
end

v.define(Vimizer::Key.new('a'), :n) do |vimizer, opt|
  vimizer.mode = :i
  pbox = PostBox.new(Vimizer.get_postbox(opt))
  pbox.move(:right, 1)
end

v.define(Vimizer::Key.new('h'), :n) do |vimizer, opt|
  pbox = PostBox.new(Vimizer.get_postbox(opt))
  pbox.move(:left, 1)
end

v.define(Vimizer::Key.new('j'), :n) do |vimizer, opt|
  pbox = PostBox.new(Vimizer.get_postbox(opt))
  pbox.move(:down, 1)
end

v.define(Vimizer::Key.new('k'), :n) do |vimizer, opt|
  pbox = PostBox.new(Vimizer.get_postbox(opt))
  pbox.move(:up, 1)
end

v.define(Vimizer::Key.new('l'), :n) do |vimizer, opt|
  pbox = PostBox.new(Vimizer.get_postbox(opt))
  pbox.move(:right, 1)
end

v.define(Vimizer::Key.new('w'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pos = pbox.buffer.cursor_position
  text = pbox.buffer.text
  new_index = Tango.next_word_head(text, pos)

  pbox = PostBox.new(Vimizer.get_postbox(opt))
  pbox.go(new_index)
end

v.define(Vimizer::Key.new('b'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pos = pbox.buffer.cursor_position
  text = pbox.buffer.text
  new_index = Tango.prev_word_head(text, pos)

  pbox = PostBox.new(Vimizer.get_postbox(opt))
  pbox.go(new_index)
end

v.plugin_eval do
  # ノーマルモードで定義されているキー以外を無視する。
  filter_keypress do |key, widget, executed|
    if v.mode == :n and widget.class.find_role_ancestor(:postbox)
      executed = true
    end
    [key, widget, executed]
  end
end
