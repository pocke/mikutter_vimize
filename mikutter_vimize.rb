# Copyright 2014, pocke
# Licensed MIT
# http://opensource.org/licenses/mit-license.php

require_relative 'lib/vimize'


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
  new_pos = buffer.cursor_position
  pbox.move_cursor(Gtk::MOVEMENT_VISUAL_POSITIONS, pos - new_pos - 1, false)
end

v.define(Vimizer::Key.new('Escape'), :i) do |vimizer, opt|
  vimizer.mode = :n
end

# ------------------------------------ Normal mode

v.define(Vimizer::Key.new('i'), :n) do |vimizer, opt|
  vimizer.mode = :i
end

v.define(Vimizer::Key.new('a'), :n) do |vimizer, opt|
  vimizer.mode = :i
  pbox = Vimizer.get_postbox(opt)
  pbox.move_cursor(Gtk::MOVEMENT_VISUAL_POSITIONS, 1, false)
end

v.define(Vimizer::Key.new('h'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pos = pbox.buffer.cursor_position
  pbox.move_cursor(Gtk::MOVEMENT_VISUAL_POSITIONS, -1, false)
end

v.define(Vimizer::Key.new('j'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pos = pbox.buffer.cursor_position
  pbox.move_cursor(Gtk::MOVEMENT_DISPLAY_LINES, 1, false)
end

v.define(Vimizer::Key.new('k'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pos = pbox.buffer.cursor_position
  pbox.move_cursor(Gtk::MOVEMENT_DISPLAY_LINES, -1, false)
end

v.define(Vimizer::Key.new('l'), :n) do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  pos = pbox.buffer.cursor_position
  pbox.move_cursor(Gtk::MOVEMENT_VISUAL_POSITIONS, 1, false)
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
