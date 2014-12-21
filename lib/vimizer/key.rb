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
    unless @ctrl or @shift or @meta
      return @main.to_sym
    end

    return :"<#{'C-' if @ctrl}#{'S-' if @shift}#{'M-' if @meta}#{@main}>"
  end

  def to_config
    "#{'Control + ' if @ctrl}#{'Shift + ' if @shift}#{'Alt + ' if @meta}#{@shift ? @main.upcase : @main}"
  end
end
