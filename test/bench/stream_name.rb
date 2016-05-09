require_relative './bench_init'

context "Stream name" do
  entity_class = EventStore::EntitySnapshot::Controls::Entity::ExampleEntity

  store = EventStore::EntitySnapshot::Store.build entity_class

  test "Category is inferred from subject" do
    id = 'some-id'

    stream_name = EventStore::EntitySnapshot::Controls::StreamName.example id

    assert store.stream_name(id) == stream_name
  end
end
