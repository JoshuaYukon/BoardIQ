class FixActiveStorageAttachmentsIndex < ActiveRecord::Migration[8.1]
  def change
    # The unique index on (record_type, record_id, name) prevents has_many_attached
    # from storing more than one file per record. Replace with a non-unique index.
    remove_index :active_storage_attachments,
                 name: "index_active_storage_attachments_uniqueness",
                 if_exists: true

    add_index :active_storage_attachments,
              [:record_type, :record_id, :name, :blob_id],
              name: "index_active_storage_attachments_on_record_name_blob",
              if_not_exists: true
  end
end
