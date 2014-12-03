# Copyright 2014, pocke
# Licensed MIT
# http://opensource.org/licenses/mit-license.php

class Vimizer
  ConfigKey = :shortcutkey_keybinds

  class << self
    def get_postbox(opt)
      Plugin.create(:gtk).widgetof(opt.widget).widget_post
    end
  end


  def initialize(slug)
    @slug = slug
    @plugin = Plugin[:slug]
  end


  def define(key, mode, &block)
    role = case mode
      when 'i'
        :postbox
      end
    name = "#{mode}_#{key.to_name}"
    slug = :"#{@slug}_#{mode}_#{key.to_slug}"

    @plugin.command(slug, {
      name:      name,
      condition: lambda {|opt| true},
      visible:   false,
      role:      role
    }, &block)

    keybind_find_or_create(key, name, slug)
  end

  def keybind_find_or_create(key, name, slug)
    bind = UserConfig[ConfigKey].values.select do |v|
      v[:key] == key.to_config and v[:name] == name and v[:slug] == slug
    end.first

    # find
    return bind if bind

    # create
    i = UserConfig[ConfigKey].keys.max + 1
    UserConfig[ConfigKey][i] = {key: key.to_config, name: name, slug: slug}
  end
end

class Vimizer::Key
  # main_key: Ex) h, a, w ...
  def initialize(main_key, ctrl: false, shift: false, meta: false)
    @main  = main_key
    @ctrl  = ctrl
    @shift = shift
    @meta  = meta
  end

  def to_slug
    :"#{'CTRL_' if @ctrl}#{'SHIFT_' if @shift}#{'META_' if @meta}#{@main.size == 1 ? @main.upcase : @main}"
  end

  def to_name
    unless @ctrl and @shift and @meta
      return @main
    end

    return :"<#{'C-' if @ctrl}#{'S-' if @shift}#{'M-' if @meta}#{@main}>"
  end

  def to_config
    "#{'Control + ' if @ctrl}#{'Shift + ' if @shift}#{'Alt + ' if @meta}#{@main}"
  end
end

Plugin.create(:vimize){}

v = Vimizer.new(:vimize)

v.define(Vimizer::Key.new('h', ctrl: true), 'i') do |opt|
  pbox = Vimizer.get_postbox(opt)
  buffer = pbox.buffer

  text = buffer.text
  pos = buffer.cursor_position
  text[pos - 1] = '' if pos - 1 >= 0
  buffer.text = text
  pbox.move_cursor(Gtk::MOVEMENT_VISUAL_POSITIONS, -(text.size - pos + 1), false)
end
