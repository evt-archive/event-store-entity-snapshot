require_relative './bench_init'

context "Writing snapshots" do
  id = Controls::ID.get
  entity = EventStore::EntitySnapshot::Controls::Entity.example
  version = EventStore::EntitySnapshot::Controls::Version.example

  store = EventStore::EntitySnapshot::Store.build entity.class
  SubstAttr::Substitute.(:writer, store)
  SubstAttr::Substitute.(:clock, store)
  store.clock.now = Controls::Time::Raw.example

  store.put id, entity, version

  test "Snapshot message is written" do
    control_message = EventStore::EntitySnapshot::Controls::Message.example

    assert store.writer do
      written? do |message|
        message == control_message
      end
    end
  end
end
