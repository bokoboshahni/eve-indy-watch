# frozen_string_literal: true

class LinkButtonComponent < ViewComponent::Base
  attr_reader :href, :size, :color, :margin

  def initialize(href:, size: :md, color: 'indigo', margin: nil)
    @href = href
    @size = size
    @color = color
    @margin = margin
  end

  def call
    link_to(content, @href, class: class_names)
  end

  def class_names
    "#{base_class_names} #{size_class_names} #{margin}"
  end

  def base_class_names
    'inline-flex items-center border border-transparent font-medium rounded shadow-sm text-white ' \
      'bg-indigo-600 dark:bg-sky-600 hover:bg-indigo-700 dark:hover:bg-sky-600 ' \
      'focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:ring-sky-500'
  end

  def size_class_names
    case @size
    when :xs
      'px-2.5 py-1.5 text-xs'
    when :sm
      'px-3 py-2 text-sm'
    when :md
      'px-4 py-2 text-sm'
    when :lg
      'px-4 py-2 text-base'
    when :xl
      'px-6 py-3 text-base'
    end
  end
end
