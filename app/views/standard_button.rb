class StandardButton < UIButton
  def on_load
    apply_style :standard_button

    on(:touch_down) do |sender|
      sender.style { |st| st.background_color = color.tint_active }
    end
  end

  def on_touch_up_inside=(value)
    on(:touch_up_inside) do |sender, event|
      sender.style { |st| st.background_color = color.tint }
      value.call(sender, event)
    end
  end

  def label=(value)
    style { |st| st.text = value }
  end

  def grid=(value)
    style { |st| st.frame = value }
  end
end
