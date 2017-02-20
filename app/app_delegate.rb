class AppDelegate < PM::Delegate
  include CDQ # Remove this if you aren't using CDQ

  status_bar true, animation: :fade

  # Without this, settings in StandardAppearance will not be correctly applied
  # Remove this if you aren't using StandardAppearance
  ApplicationStylesheet.new(nil).application_setup

  def on_load(app, options)
    return true if RUBYMOTION_ENV == 'test'

    cdq.setup # Remove this if you aren't using CDQ
    open RegistrationScreen.new(nav_bar: true)
  end
end
