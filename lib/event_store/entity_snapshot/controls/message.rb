module EventStore
  module EntitySnapshot
    module Controls
      module Message
        def self.example(id=nil)
          id ||= ID.example

          instance = EntitySnapshot::Message.new
          instance.id = id
          instance.data = Entity::Data.example
          instance.version = Version.example
          instance.time = Time.example

          instance
        end
      end
    end
  end
end
