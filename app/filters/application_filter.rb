# frozen_string_literal: true

class ApplicationFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  class_attribute :sorters
  self.sorters = {}

  class_attribute :facets
  self.facets = {}

  attr_reader :scope

  def initialize(session)
    @session = session

    super(@session.fetch(:filters, {})[filter_resource_class])
  end

  def self.sorter(name, opts = {})
    sorters[name] = opts
  end

  def self.facet(name, opts = {})
    facets[name.to_sym] = opts
  end

  def apply!(_scope); end

  def clear!
    @session[:filters] ||= {}
    @session[:filters][filter_resource_class] ||= {}
    @session[:filters][filter_resource_class] = @session[:filters][filter_resource_class].slice('sort')
  end

  def merge!(attribute, value)
    @session[:filters] ||= {}
    @session[:filters][filter_resource_class] ||= {}

    send(:"#{attribute}=", value)

    @session[:filters][filter_resource_class].merge!(attribute => send(attribute))
  end

  def active?
    @session[:filters][filter_resource_class] ||= {}
    @session[:filters][filter_resource_class].except('sort').values.any?(&:present?)
  end

  def active_for?(attribute, value = true)
    filter_attribute = send(attribute)

    return filter_attribute.include?(value) if filter_attribute.is_a?(Enumerable)

    filter_attribute == value
  end

  def filter_resource_class
    @filter_resource_class || self.class.name.match(/\A(?<resource>.*)Filter\z/)[:resource]
  end

  def facet_items(field)
    send(:"#{field}_items") || []
  end

  def facet_item_selected?(facet, value)
    send(facet).include?(value)
  end

  def facet_active?(facet)
    send(facet).any?
  end
end
