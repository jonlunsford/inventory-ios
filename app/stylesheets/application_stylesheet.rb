class ApplicationStylesheet < RubyMotionQuery::Stylesheet
  include StandardButtonStylesheet

  def application_setup

    # Change the default grid if desired
    rmq.app.grid.tap do |g|
      g.num_columns =  12
      g.column_gutter = 10
      g.num_rows = 18
      g.row_gutter = 10
      g.content_left_margin = 10
      g.content_top_margin = 74
      g.content_right_margin = 10
      g.content_bottom_margin = 10
    end

    # An example of setting standard fonts and colors
    font_regular = 'HelveticaNeue'
    font_light = 'HelveticaNeue-Light'
    font_bold = 'HelveticaNeue-Bold'
    font_italic = 'HelveticaNeue-Italic'

    font.add_named :large,    font_regular, 36
    font.add_named :medium,   font_regular, 24
    font.add_named :small,    font_regular, 18
    font.add_named :title,        font_bold, 20
    font.add_named :title_light,  font_light, 20
    font.add_named :body_title,   font_bold, 16
    font.add_named :body_title_light,   font_light, 16
    font.add_named :sub_title,    font_bold, 14
    font.add_named :body,         font_regular, 14
    font.add_named :italic,       font_italic, 14
    font.add_named :light,        font_light, 14
    font.add_named :stat,         font_light, 40

    color.add_named :tint, '236EB7'
    color.add_named :tint_active, '2c83dc'
    color.add_named :translucent_black, color(0, 0, 0, 0.4)
    color.add_named :battleship_gray, '#7F7F7F'
    color.add_named :light_grey, 'EFEFEF'
    color.add_named :medium_grey, 'C1C1C1'
    color.add_named :dark_grey, '333333'
    color.add_named :primary_accent, 'C41230'
    color.add_named :secondary_accent, 'F1E5C8'
    color.add_named :tertiary_accent, '428E21'
    color.add_named :primary_font, '3F3F3F'
    color.add_named :secondary_font, '919191'
    color.add_named :tertiary_font, '717171'
    color.add_named :form_label, '5a5a5a'
    color.add_named :primary_bg, 'EFEFEF'
    color.add_named :secondary_bg, 'F6F6F8'
    color.add_named :tertiary_bg, '282828'
    color.add_named :danger, 'FF1F1F'
    color.add_named :transparent_dark, color(0, 0, 0, 0.1)
    color.add_named :transparent_light, color(255, 255, 255, 0.8)
    color.add_named :state_active, color(117, 117, 117, 1)

    StandardAppearance.apply app.window
  end

  def root_view(st)
    st.frame = :full
    st.background_color = color.primary_bg
  end

  def centered_view_title(st)
    st.frame = 'a1:l1'
    st.text_alignment = :center
    st.font = font.title_light
    st.color = color.black
    st.background_color = color.clear
  end

  def standard_text_field(st)
    st.border_style = UITextBorderStyleRoundedRect
  end

  def standard_label(st)
    st.frame = { w: 40, h: 18 }
    st.background_color = color.clear
    st.color = color.black
  end

  def emphasis(st)
    st.text_alignment = :center
    st.font = font.italic
    st.color = color.tint
  end

  def rounded_image(st)
    st.view.layer.cornerRadius = st.frame.width / 2
    st.clips_to_bounds = true
  end
end
