# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def sidebar_item_text_class(item_name)
    controller_name == item_name ? 'bg-gray-900 text-white' : 'text-gray-300 hover:bg-gray-700 hover:text-white'
  end

  def sidebar_item_icon_class(item_name)
    controller_name == item_name ? 'text-gray-300' : 'text-gray-400 group-hover:text-gray-300'
  end

  def site_name
    app_config.site_name
  end

  def number_to_isk(value)
    number_with_precision value, precision: 2, delimiter: ',', strip_insignificant_zeros: true
  end

  def number_to_m3(value)
    number_with_precision value, precision: 2, delimiter: ',', strip_insignificant_zeros: true
  end
end
