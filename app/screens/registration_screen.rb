class RegistrationScreen < PM::Screen
  include JSONAPI::Helpers
  include InventoryIO::ScreenHelpers

  title 'Registration'
  stylesheet ApplicationStylesheet

  def on_load
    title = append!(UILabel, :centered_view_title)
    title.text = 'Inventory IO'

    append(UITextField, :standard_text_field).style do |st|
      st.frame = 'a3:l4'
      st.keyboard_type = UIKeyboardTypeEmailAddress
      st.autocapitalization_type = UITextAutocapitalizationTypeNone
      st.placeholder = 'Email'
    end.tag(:email)

    append(UITextField, :standard_text_field).style do |st|
      st.frame = 'a5:l6'
      st.secure_text_entry = true
      st.placeholder = 'Password'
    end.tag(:password)

    append(UITextField, :standard_text_field).style do |st|
      st.frame = 'a7:l8'
      st.secure_text_entry = true
      st.placeholder = 'Password Confirmation'
    end.tag(:password_confirmation)

    append(StandardButton).attr(grid: 'a9:l10',
                                label: 'Register',
                                on_touch_up_inside: proc { register_user })

    footer = append(UILabel, :emphasis).style do |st|
      st.frame = 'a11:l11'
      st.attributed_text = mastr('Already have an account? Log In.', underline_style: :style_single).build
    end

    footer.on(:tap) { open LogInScreen.new(nav_bar: true) }
  end

  def register_user
    hide_keyboard
    notifier.loading(:gradient)

    user = User.create(values)

    user.register do |result|
      if result.success?
        notifier.dismiss
        #cdq.save
      elsif result.failure?
        notifier.error parse_request_errors(result)
      end
    end
  end

  def values
    {
      email: find(:email).get.text,
      password: find(:password).get.text,
      password_confirmation: find(:password_confirmation).get.text,
      current_user: true
    }
  end
end
