module HyperKittenMeow
  MenuDefinition = Data.define(:key, :depth, :label) do
    def self.from_config(menus)
      menus.to_h.each_with_object({}) do |(key, options), definitions|
        definition = build(key, options || {})
        definitions[definition.key] = definition
      end.freeze
    end

    def self.build(key, options)
      key = key.to_sym
      unknown = options.keys.map(&:to_sym) - members.excluding(:key)
      if unknown.any?
        raise ArgumentError, "Menu #{key.inspect} has unknown option(s) #{unknown.map(&:inspect).join(", ")}. " \
                             "Menus take depth: and label:."
      end

      depth = options.fetch(:depth, 1)
      unless depth.is_a?(Integer) && depth >= 1
        raise ArgumentError, "Menu #{key.inspect} needs a depth of 1 or more, got #{depth.inspect}."
      end

      new(key: key, depth: depth, label: options[:label] || "#{key.to_s.humanize} menu")
    end
  end
end
