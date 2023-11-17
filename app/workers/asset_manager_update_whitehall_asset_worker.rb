class AssetManagerUpdateWhitehallAssetWorker < WorkerBase
  sidekiq_options queue: "asset_manager_updater"

  def perform(klass, id, attributes)
    model = klass.constantize.find(id)
    asset_data = GlobalID::Locator.locate(model.to_global_id)

    if should_use_non_legacy_endpoints?(asset_data)
      asset_data.assets.each do |asset|
        AssetManager::AssetUpdater.call(asset.asset_manager_id, asset_data, nil, attributes)
      end
    else
      path = asset_data.file.asset_manager_path
      AssetManager::AssetUpdater.call(nil, asset_data, path, attributes)

      # Update any other versions of the file (e.g. PDF thumbnail, or resized versions of an image)
      asset_versions = asset_data.file.versions.values.select(&:present?)
      asset_versions.each do |version|
        AssetManager::AssetUpdater.call(nil, asset_data, version.asset_manager_path, attributes)
      end
    end
  rescue AssetManager::ServiceHelper::AssetNotFound,
         AssetManager::AssetUpdater::AssetAlreadyDeleted,
         ActiveRecord::RecordNotFound => e
    logger.error "AssetManagerUpdateWhitehallAssetWorker: #{e.message}"
  end

private

  def should_use_non_legacy_endpoints?(asset_data)
    asset_data.instance_of?(AttachmentData) || asset_data.instance_of?(ImageData) || asset_data.instance_of?(ConsultationResponseFormData)
  end
end
