module TemporaryUploadSupport

  def remember_temp_upload(id)
    flash[:upload] = id
  end

  def remove_temp_upload
    flash[:upload] = nil
  end

end