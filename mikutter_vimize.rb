# Copyright 2014, pocke
# Licensed MIT
# http://opensource.org/licenses/mit-license.php

require_relative 'lib/vimizer'
require_relative 'lib/tango'


Plugin.create(:vimize){}

v = Vimizer.new(:vimize)

# ----------------------------------- Insert mode

v.define(Vimizer::Key.new('h', ctrl: true), :i) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pos = pbox.cursor_position

  pbox.delete(pos -1) if pos - 1 >= 0
end

v.define(Vimizer::Key.new('Escape'), :i) do |vimizer, opt|
  vimizer.mode = :n
end

v.define(Vimizer::Key.new('w', ctrl: true), :i) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pos = pbox.cursor_position
  text = pbox.text
  first, _ = Tango.get_index(text, pos -1)

  pbox.delete(first..(pos - 1))
end

# ------------------------------------ Normal mode

v.define(Vimizer::Key.new('i'), :n) do |vimizer, opt|
  vimizer.mode = :i
end

v.define(Vimizer::Key.new('a'), :n) do |vimizer, opt|
  vimizer.mode = :i
  pbox = Vimizer.get_postbox(opt)
  pbox.move(:right, 1)
end

v.define(Vimizer::Key.new('i', shift: true), :n) do |vimizer, opt|
  vimizer.mode = :i
  pbox = Vimizer.get_postbox(opt)
  t = pbox.text
  pos = pbox.cursor_position
  to = t.rindex("\n", pos - 1) || -1
  to += 1
  pbox.go(to)
end

v.define(Vimizer::Key.new('a', shift: true), :n) do |vimizer, opt|
  vimizer.mode = :i
  pbox = Vimizer.get_postbox(opt)
  t = pbox.text
  pos = pbox.cursor_position
  to = t.index("\n", pos) || t.size
  pbox.go(to)
end

v.define(Vimizer::Key.new('h'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pbox.move(:left, 1)
end

v.define(Vimizer::Key.new('j'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pbox.move(:down, 1)
end

v.define(Vimizer::Key.new('k'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pbox.move(:up, 1)
end

v.define(Vimizer::Key.new('l'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pbox.move(:right, 1)
end

v.define(Vimizer::Key.new('w'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pos = pbox.cursor_position
  text = pbox.text
  new_index = Tango.next_word_head(text, pos)

  pbox.go(new_index)
end

v.define(Vimizer::Key.new('b'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pos = pbox.cursor_position
  text = pbox.text
  new_index = Tango.prev_word_head(text, pos)

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
