require_relative '../bench_init'

context "Reading snapshots that have not been written" do
  id = Identifier::UUID::Random.get

  entity_class = EventStore::EntitySnapshots::Controls::Entity::ExampleEntity
  store = EventStore::EntitySnapshots::Store.build entity_class

  entity, version, time = store.get id

  test "No entity is returned" do
    assert entity == nil
  end

  test "No version is returned" do
    assert version == nil
  end

  test "No time is returned" do
    assert time == nil
  end
end
