module StandardButtonStylesheet
  def standard_button(st)
    st.background_color = color.tint
    st.color = color.white
    st.view.layer.cornerRadius = 5
  end
end
