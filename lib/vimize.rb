class Vimizer
  require_relative 'vimize/key'

  ConfigKey = :shortcutkey_keybinds

  class InvalidMode < StandardError; end

  class << self
    # ==== Return
    # Gtk::TextView
    def get_postbox(opt)
      Plugin.create(:gtk).widgetof(opt.widget).widget_post
    end
  end


  def initialize(slug)
    @slug = slug
    @plugin = Plugin[:slug]
    @mode = :i
  end
  attr_accessor :mode


  # mikutterコマンドと、shortcutkeyを定義する。
  # ==== Args
  # [key] Vimizer::Key
  # [mode] モードを表すSymbol
  # [&block] mikutterコマンドの実態。第一引数にVimizer, 第二引数にはいつものアレが渡される。
  def define(key, mode, &block)
    block = block.curry(2)[self]

    role = case mode
      when :i, :n
        :postbox
      else
        raise InvalidMode, "#{mode} is invalid mode."
      end
    name = "#{mode}_#{key.to_name}"
    slug = :"#{@slug}_#{mode}_#{key.to_slug}"

    @plugin.command(slug, {
      name:      name,
      condition: lambda {|opt| @mode == mode},
      visible:   false,
      role:      role
    }, &block)

    keybind_find_or_create(key, name, slug)
  end

  # shortcutkeyが存在すればそれを返し、存在しなければ新しくshortcutkeyを作成して返す。
  # ==== Args
  # [key] Vimizer::Key
  # [name] shortcutkey に登録される name
  # [slug] shortcutkey に登録される slug
  # ==== Return
  # UserConfig に格納されている Hash
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

  # pluginのコンテキストでblockを実行する。
  def plugin_eval(&block)
    @plugin.instance_eval(&block)
  end
end
