class ContentObjectStore::ContentBlockDocument < ApplicationRecord
  has_many :content_block_editions,
           -> { order(created_at: :asc, id: :asc) },
           inverse_of: :content_block_document

  enum :block_type, ContentObjectStore::ContentBlockSchema.valid_schemas.index_with(&:to_s)
  attr_readonly :block_type

  validates :block_type, :title, presence: true

  has_one :latest_edition,
          -> { joins(:content_block_document).where("content_block_documents.latest_edition_id = content_block_editions.id") },
          class_name: "ContentBlockEdition",
          inverse_of: :content_block_document
end
