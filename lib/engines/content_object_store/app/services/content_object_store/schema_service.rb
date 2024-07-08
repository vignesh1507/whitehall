module ContentObjectStore
  class SchemaService
    SCHEMA_PREFIX = "content_block".freeze

    def self.schema_for_block_type(block_type)
      full_schema = Services.publishing_api.get_schema("#{SCHEMA_PREFIX}_#{block_type}")
      full_schema.dig("definitions", "details") || raise(ArgumentError, "Cannot find schema for #{block_type}")
    rescue GdsApi::HTTPNotFound
      raise ArgumentError, "Invalid block_type: #{block_type}"
    end
  end
end
