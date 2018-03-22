class CsvPreviewController < BaseAttachmentsController
  def show
    respond_to do |format|
      format.html do
        if attachment_data.csv? && attachment_visible? && attachment_data.visible_edition_for(current_user)
          expires_headers
          @edition = attachment_data.visible_edition_for(current_user)
          @attachment = attachment_data.visible_attachment_for(current_user)
          @csv_preview = CsvFileFromPublicHost.csv_preview(attachment_data.file.asset_manager_path)
          render layout: 'html_attachments'
        else
          fail
        end
      end
    end
  end

private

  def fail
    if attachment_data.unpublished?
      redirect_url = attachment_data.unpublished_edition.unpublishing.document_path
      redirect_to redirect_url
    elsif attachment_data.replaced?
      expires_headers
      redirect_to attachment_data.replaced_by.url, status: 301
    elsif incoming_upload_exists? upload_path
      if image? upload_path
        redirect_to view_context.path_to_image('thumbnail-placeholder.png')
      else
        redirect_to_placeholder
      end
    else
      render plain: "Not found", status: :not_found
    end
  end
end
