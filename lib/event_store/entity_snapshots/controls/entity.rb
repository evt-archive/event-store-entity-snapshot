module EventStore
  module EntitySnapshots
    module Controls
      module Entity
        class ExampleEntity
          include Schema::DataStructure

          attribute :some_attribute

          module Serializer
            def self.raw_data(instance)
              instance.to_h
            end

            def self.instance(raw_data)
              ExampleEntity.build raw_data
            end
          end
        end

        module Data
          def self.example
            entity = Entity.example
            Serialize::Write.raw_data entity
          end
        end

        def self.example
          instance = ExampleEntity.new
          instance.some_attribute = Value.example
          instance
        end
      end
    end
  end
end
