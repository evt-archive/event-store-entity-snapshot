require_relative './bench_init'

context "Writing snapshots" do
  id = EventStore::EntitySnapshot::Controls::ID.example
  entity = EventStore::EntitySnapshot::Controls::Entity.example
  version = EventStore::EntitySnapshot::Controls::Version.example
  time = EventStore::EntitySnapshot::Controls::Time.example

  store = EventStore::EntitySnapshot::Controls::Store.example
  SubstAttr::Substitute.(:write, store)

  store.put id, entity, version, time

  test "Snapshot message is written" do
    control_message = EventStore::EntitySnapshot::Controls::Message.example

    assert store.write do
      written? do |message|
        message == control_message
      end
    end
  end
end
