module EventStore
  module EntitySnapshots
    module Controls
      module StreamName
        def self.example(id=nil)
          id ||= ::Controls::ID.get

          EventStore::Messaging::StreamName.stream_name id, Category.example
        end

        module Category
          def self.example
            'exampleEntity:snapshot'
          end
        end
      end
    end
  end
end
