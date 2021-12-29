module Filterable
  extend ActiveSupport::Concern

  included do
    if respond_to?(:helper_method)
      helper_method :filter_active_for?
      helper_method :filter_for
    end
  end

  def filter_active_for?(resource, attribute, value = true)
    filter = filter_for(resource)
    filter.active_for?(attribute, value)
  end

  private

  def store_filters!(resource)
    filter_for(resource).clear!
    filter_params(resource).each { |k, v| set_filter_for!(resource, k, v) }
  end

  def filter_for(resource)
    "#{resource}Filter".constantize.new(session)
  end

  def set_filter_for!(resource, param, value)
    filter_for(resource).merge!(param, value)
  end

  def filter_params(resource)
    names = []
    array_names = []
    filter_class = "#{resource}Filter".constantize
    filter_class.attribute_types.each_key do |name|
      filter_class.array_attributes.include?(name.to_s) ? array_names << name.to_sym : names << name
    end
    params.permit(*names, **array_names.each_with_object({}) { |n, h| h[n] = [] })
  end
end
