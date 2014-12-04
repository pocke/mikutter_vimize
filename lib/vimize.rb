class Vimizer
  require_relative 'vimize/key'

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