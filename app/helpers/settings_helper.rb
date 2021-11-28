module SettingsHelper
  def settings_tab_text_class(tab_name)
    controller_name == tab_name ? "border-purple-500 text-purple-600" : "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700"
  end
end
