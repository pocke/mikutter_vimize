# Copyright 2014, pocke
# Licensed MIT
# http://opensource.org/licenses/mit-license.php

require_relative 'lib/vimize'


Plugin.create(:vimize){}

v = Vimizer.new(:vimize)

v.define(Vimizer::Key.new('h', ctrl: true), 'i') do |vimizer, opt|
  pbox = Vimizer.get_postbox(opt)
  buffer = pbox.buffer

  text = buffer.text
  pos = buffer.cursor_position
  text[pos - 1] = '' if pos - 1 >= 0
  buffer.text = text
  new_pos = buffer.cursor_position
  pbox.move_cursor(Gtk::MOVEMENT_VISUAL_POSITIONS, pos - new_pos - 1, false)
end
