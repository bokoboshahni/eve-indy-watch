class ApplicationFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  class_attribute :sorters
  class_attribute :array_attributes
  class_attribute :labels
  class_attribute :facets
  class_attribute :facet_labels

  self.facets = {}

  def initialize(session)
    @session = session

    super(@session.fetch(:filters, {})[filter_resource_class])
  end

  def self.facet(name, opts = {})
    facets[name.to_sym] = opts
  end

  def apply!(_chain)
  end

  def clear!
    @session[:filters] ||= {}
    @session[:filters][filter_resource_class] ||= {}
    @session[:filters][filter_resource_class] = @session[:filters][filter_resource_class].slice('sort')
  end

  def merge!(_attribute, _value)
    @session[:filters] ||= {}
    @session[:filters][filter_resource_class] ||= {}
  end

  def active?
    @session[:filters][filter_resource_class] ||= {}
    @session[:filters][filter_resource_class].except('sort').values.any? { |v| v.present? }
  end

  def active_for?(attribute, value = true)
    filter_attribute = send(attribute)

    return filter_attribute.include?(value) if filter_attribute.is_a?(Enumerable)

    filter_attribute == value
  end

  def filter_resource_class
    @filter_resource_class || self.class.name.match(/\A(?<resource>.*)Filter\z/)[:resource]
  end
end
