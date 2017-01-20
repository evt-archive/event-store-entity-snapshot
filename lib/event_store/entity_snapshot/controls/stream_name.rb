module EventStore
  module EntitySnapshot
    module Controls
      module StreamName
        def self.example(id=nil)
          id ||= ::Controls::ID.get

          ::Messaging::StreamName.stream_name id, Category.example
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
