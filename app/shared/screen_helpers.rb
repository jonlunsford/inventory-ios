module InventoryIO
  module ScreenHelpers
    def notifier
      @notifier ||= Motion::Blitz
    end

    def hide_keyboard
      find(UITextField).each(&:resignFirstResponder)
    end
  end
end
