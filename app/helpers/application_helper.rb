# frozen_string_literal: true

module ApplicationHelper
  include BetterHtml::Helpers
  include Pagy::Frontend

  def sidebar_item_text_class(item_name)
    if controller_name == item_name
      'bg-gray-900 dark:bg-zinc-900 dark:bg-zinc-900 text-white'
    else
      'text-gray-300 dark:text-zinc-300 dark:text-zinc-300 hover:bg-gray-700 ' \
        'dark:hover:bg-zinc-700 hover:text-white'
    end
  end

  def sidebar_item_icon_class(item_name)
    if controller_name == item_name
      'text-gray-300 dark:text-zinc-300 dark:text-zinc-300'
    else
      'text-gray-400 dark:text-zinc-400 dark:text-zinc-400 ' \
        'group-hover:text-gray-300 dark:group-hover:text-zinc-300 dark:hover:text-zinc-300'
    end
  end

  def number_to_isk(value)
    number_with_precision value, precision: 2, delimiter: ',', strip_insignificant_zeros: true
  end

  def number_to_m3(value)
    number_with_precision value, precision: 2, delimiter: ',', strip_insignificant_zeros: true
  end
end
