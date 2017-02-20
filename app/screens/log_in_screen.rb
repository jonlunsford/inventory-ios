class LogInScreen < PM::Screen
  include JSONAPI::Helpers
  include InventoryIO::ScreenHelpers

  title 'Log In'
  stylesheet ApplicationStylesheet

  def on_load
    set_nav_bar_button :back, title: " ", style: :plain, action: :back

    title = append!(UILabel, :centered_view_title)
    title.text = 'Inventory IO'

    append(UITextField, :standard_text_field).style do |st|
      st.frame = 'a5:l6'
      st.keyboard_type = UIKeyboardTypeEmailAddress
      st.autocapitalization_type = UITextAutocapitalizationTypeNone
      st.placeholder = 'Email'
    end.tag(:email)

    append(UITextField, :standard_text_field).style do |st|
      st.frame = 'a7:l8'
      st.secure_text_entry = true
      st.placeholder = 'Password'
    end.tag(:password)

    append(StandardButton).attr(grid: 'a9:l10',
                                label: 'Log In',
                                on_touch_up_inside: proc { log_in_user })
  end

  def user
    @user ? @user.update(values) : User.create(values)
  end

  def log_in_user
    hide_keyboard
    notifier.loading(:gradient)

    user.log_in do |result|
      if result.success?
        notifier.success
      elsif result.failure?
        notifier.error parse_request_errors(result)
      end
    end
  end

  def values
    {
      email: find(:email).get.text,
      password: find(:password).get.text
    }
  end
end
