class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video
  include CarrierWave::Video::Thumbnailer
  
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def extension_white_list
    %w(mp4 mov)
  end
  
  process encode_video: [:mp4, resolution: "640x480"]
  
  version :mp4 do
    def full_filename(for_file)
      super.chomp(File.extname(super)) + '.mp4'
    end
  end
  
  version :cover_image do
    process thumbnail: [{format: 'jpg', quality: 10, size: 192, strip: false, logger: Rails.logger}]
    def full_filename for_file
      jpg_name for_file, version_name
    end
  end
  
  def jpg_name for_file, version_name
    %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.jpg}
  end
  
end