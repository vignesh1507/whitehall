content_ids = %w(
  60221f79-7631-11e4-a3cb-005056011aef
  5f5a1fa5-7631-11e4-a3cb-005056011aef
  5f561925-7631-11e4-a3cb-005056011aef
  5f550241-7631-11e4-a3cb-005056011aef
  44dae31b-a5f6-4d2d-8985-0bf4f023a4e4
  5feb8687-7631-11e4-a3cb-005056011aef
  5f564303-7631-11e4-a3cb-005056011aef
  5fa9d4ba-7631-11e4-a3cb-005056011aef
  5f5a509d-7631-11e4-a3cb-005056011aef
  5f564227-7631-11e4-a3cb-005056011aef
  5f54d009-7631-11e4-a3cb-005056011aef
  602e5786-7631-11e4-a3cb-005056011aef
  9c5ba23a-969d-4c9b-be2b-71e54d37814a
  d6a22152-0b00-42ec-84af-68a26798cc19
  bfa8d2d7-d199-4116-b68d-aa1b37e0cb0b
  602278fe-7631-11e4-a3cb-005056011aef
  5fe3c735-7631-11e4-a3cb-005056011aef
  5fa9e5f3-7631-11e4-a3cb-005056011aef
  5f55c163-7631-11e4-a3cb-005056011aef
  602ebb6a-7631-11e4-a3cb-005056011aef
  5fe90587-7631-11e4-a3cb-005056011aef
  02a45bb3-9d86-4768-86a6-1caf771cbeb4
  5fe3ca99-7631-11e4-a3cb-005056011aef
  5fec13f4-7631-11e4-a3cb-005056011aef
  5fe3c59c-7631-11e4-a3cb-005056011aef
  5f5a3310-7631-11e4-a3cb-005056011aef
  5fe3c67c-7631-11e4-a3cb-005056011aef
  5fa9e552-7631-11e4-a3cb-005056011aef
  60f036fe-d870-4bab-bc64-3f3f6cb5854b
  5f5a2d6e-7631-11e4-a3cb-005056011aef
  5fe611aa-7631-11e4-a3cb-005056011aef
  5fa475be-7631-11e4-a3cb-005056011aef
  602adf53-7631-11e4-a3cb-005056011aef
)

ids = Document.where(content_id: content_ids).pluck(:id)
ids.each do |id|
  PublishingApiDocumentRepublishingWorker.perform_async_in_queue("bulk_republishing", id)
  print "."
end

puts
