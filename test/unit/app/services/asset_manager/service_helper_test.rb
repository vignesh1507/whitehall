require "test_helper"

class AssetManager::ServiceHelperTest < ActiveSupport::TestCase
  extend Minitest::Spec::DSL

  setup do
    @asset_manager_id = "asset-id"
    @asset_url = "http://asset-manager/assets/#{@asset_manager_id}"
    @worker = Object.new
    @worker.extend(AssetManager::ServiceHelper)
  end

  describe "find_asset_by_id" do
    test "returns attributes including asset URL" do
      Services.asset_manager.stubs(:asset).with(@asset_manager_id)
              .returns(gds_api_response("id" => @asset_url))

      response = @worker.send(:find_asset_by_id, @asset_manager_id)

      assert_equal @asset_url, response["id"]
    end

    test "returns other attributes" do
      Services.asset_manager.stubs(:asset).with(@asset_manager_id)
              .returns(gds_api_response("id" => @asset_url, "key" => "value"))

      attributes = @worker.send(:find_asset_by_id, @asset_manager_id)

      assert_equal "value", attributes["key"]
    end

    test "raises AssetNotFound when an asset is not available" do
      Services.asset_manager.stubs(:asset).with(@asset_manager_id)
              .raises(GdsApi::HTTPNotFound.new(404))

      assert_raises AssetManager::ServiceHelper::AssetNotFound do
        @worker.send(:find_asset_by_id, @asset_manager_id)
      end
    end
  end

private

  def gds_api_response(attributes = {})
    http_response = stub("http_response", body: attributes.to_json)
    GdsApi::Response.new(http_response)
  end
end
