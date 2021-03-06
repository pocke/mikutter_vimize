class Vimizer::PostBox
  # ==== Args
  # [pbox] Gtk::TextView
  def initialize(pbox)
    @pbox = pbox
  end

  # ==== Args
  # [to] 移動したい位置
  def go(to)
    pos = @pbox.buffer.cursor_position

    move(:right, to - pos)
  end

  # ==== Args
  # [direction] 移動したい方向。 :up, :down, :right, :left
  # [n] 移動する量
  def move(direction, n)
    step, sign = case direction
      when :up
        [Gtk::MOVEMENT_DISPLAY_LINES, -1]
      when :down
        [Gtk::MOVEMENT_DISPLAY_LINES, 1]
      when :right
        [Gtk::MOVEMENT_VISUAL_POSITIONS, 1]
      when :left
        [Gtk::MOVEMENT_VISUAL_POSITIONS, -1]
      else
        raise ArgumentError, "#{direction} is invalid."
      end

    unless n == 0
      @pbox.move_cursor(step, sign * n, false)
    end
  end

  def delete(position)
    to = case position
      when Integer
        position
      when Range
        position.begin
      else
        raise ArgumentError, "Position should be Integer or Range"
      end

    t = text
    t[position] = ''
    self.text = t

    go(to)
  end

  def text
    return @pbox.buffer.text
  end

  def text=(str)
    @pbox.buffer.text = str
  end

  def cursor_position
    return @pbox.buffer.cursor_position
  end
end
