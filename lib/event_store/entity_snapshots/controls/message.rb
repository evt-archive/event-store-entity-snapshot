module EventStore
  module EntitySnapshots
    module Controls
      module Message
        def self.example(id=nil)
          id ||= ::Controls::ID.get

          instance = EntitySnapshots::Message.new
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
