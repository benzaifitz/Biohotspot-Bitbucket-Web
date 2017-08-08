module Users::SessionsHelper

  def render_or_call_method_or_proc_on(obj, string_symbol_or_proc, options = {})
    case string_symbol_or_proc
      when Symbol, Proc
        call_method_or_proc_on(obj, string_symbol_or_proc, options)
      when String
        string_symbol_or_proc
    end
  end

  def flash_messages
    @flash_messages ||= flash.to_hash.with_indifferent_access.except(*ActiveAdmin.application.flash_keys_to_except)
  end

end
