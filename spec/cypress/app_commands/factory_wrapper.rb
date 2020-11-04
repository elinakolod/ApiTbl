class FactoryWrapper
  INTERPOLATION_REGEX = /\{\{(.*?)\}\}/.freeze

  def initialize(factories_options)
    @factories_options = factories_options
  end

  def self.call(factories_options)
    new(factories_options).call
  end

  def call
    factories_options.each do |factory_options|
      object_name = factory_options.shift
      next if object_name.present? && instance_variable_get("@#{object_name}")
      create_factory(object_name, factory_options)
    end
  end

  private

  attr_reader :factories_options

  def create_factory(object_name, factory_options)
    factory_method = factory_options.shift
    parsed_options = parse_factory_options(factory_options)
    factory = FactoryBot.create(factory_method, *parsed_options)
    instance_variable_set("@#{object_name}", factory) if object_name.present?
    factory
  end

  def parse_factory_options(factory_options)
    entity_params = factory_options.last
    return factory_options unless entity_params.is_a?(Hash)
    entity_params.transform_values!(&method(:interpolate))
    [*factory_options[0...-1], entity_params]
  end

  def interpolate(text)
    return text unless INTERPOLATION_REGEX.match(text)
    entity_name, attribute = Regexp.last_match(1).strip.split('.')
    entity = get_entity_value(entity_name)
    return entity if attribute.blank?
    entity.public_send(attribute)
  end

  def get_entity_value(entity_name)
    entity = instance_variable_get("@#{entity_name}")
    return entity if entity.present?
    load_entity_factory(entity_name)
  end

  def load_entity_factory(entity_name)
    factory_options = factories_options.detect { |options| options[0] == entity_name }
    raise StandardError, "Factory has unresolve dependency #{entity_name}" if factory_options.blank?
    puts '++++++++++++++++++++++++++++++'
    p factory_options
    create_factory(entity_name, factory_options[1..-1])
  end
end
