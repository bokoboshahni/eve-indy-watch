# frozen_string_literal: true

module SettingsHelper
  def settings_tab_text_class(tab_name)
    if controller_name == tab_name
      'border-indigo-500 text-indigo-600 dark:border-sky-500 dark:text-sky-500'
    else
      'border-transparent text-gray-500 dark:text-zinc-500 dark:text-zinc-200 hover:border-gray-300 dark:hover:border-zinc-700 ' \
        'dark:hover:border-zinc-700 hover:text-gray-700 dark:hover:text-zinc-300 dark:hover:text-zinc-300'
    end
  end
end
