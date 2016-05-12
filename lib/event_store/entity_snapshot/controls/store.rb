module EventStore
  module EntitySnapshot
    module Controls
      module Store
        class Example
          include EntitySnapshot

          category :some_category
        end

        def self.example
          entity_class = Controls::Entity::ExampleEntity

          Example.build entity_class
        end
      end
    end
  end
end
