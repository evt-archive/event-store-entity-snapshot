module EventStore
  module EntitySnapshot
    module Controls
      module Entity
        class ExampleEntity
          include Schema::DataStructure

          attribute :some_attribute

          def ==(other)
            other.is_a?(self.class) &&
              some_attribute == other.some_attribute
          end

          module Transformer
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
            Transform::Write.raw_data entity
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
