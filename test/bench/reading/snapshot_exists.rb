require_relative '../bench_init'

context "Reading snapshots that have been previously written" do
  id = EventStore::EntitySnapshot::Controls::ID.example
  control_entity = EventStore::EntitySnapshot::Controls::Entity.example
  control_version = EventStore::EntitySnapshot::Controls::Version.example
  control_time = EventStore::EntitySnapshot::Controls::Time.example

  store = EventStore::EntitySnapshot::Controls::Store.example

  store.put id, control_entity, control_version, control_time

  entity, version, time = store.get id

  test "Original entity is returned" do
    assert entity == control_entity
    assert entity.object_id != control_entity.object_id
  end

  test "Version is returned" do
    assert version == control_version
  end

  test "Snapshot time is returned" do
    assert time == control_time
  end
end
