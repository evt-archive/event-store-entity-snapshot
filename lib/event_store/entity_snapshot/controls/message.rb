module EventStore
  module EntitySnapshot
    module Controls
      module Message
        def self.example(id=nil)
          id ||= ::Controls::ID.get

          instance = EntitySnapshot::Message.new
          instance.id = id
          instance.data = Entity::Data.example
          instance.version = Version.example
          instance.time = ::Controls::Time.reference

          instance
        end
      end
    end
  end
end
