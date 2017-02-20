module InventoryIO
  module ScreenHelpers
    include MotionMastr

    def notifier
      @notifier ||= Motion::Blitz
    end

    def hide_keyboard
      find(UITextField).each(&:resignFirstResponder)
    end

    def current_user
      @current_user ||= User.where(:current_user).eq(true).first
    end
  end
end
