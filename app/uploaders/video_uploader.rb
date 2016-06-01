class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video
  # include CarrierWave::Video::Thumbnailer
  
  storage :qiniu
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def filename
    if super.present?
      "#{secure_token}.#{file.extension}"
    end
  end
  
  def extension_white_list
    %w(mp4 mov avi 3gp mpeg)
  end
  
  def move_to_cache
    true
  end
  
  def move_to_store
    true
  end
  
  # process encode_video: [:mp4, custom: "-preset medium -pix_fmt yuv420p"]
  # :custom => "-strict experimental -q:v 5 -preset slow -g 30"
  # process :encode_video=> [:mp4, audio_codec: "aac", resolution: :same, video_bitrate: :same]
  
  # version :mp4 do
  #   process :encode_video=> [:mp4, audio_codec: "aac", resolution: :same, video_bitrate: :same]
  #   def full_filename(for_file)
  #     super.chomp(File.extname(super)) + '.mp4'
  #   end
  # end
  
  # version :cover_image do
  #   process thumbnail: [{format: 'jpg', quality: 10, size: 192, strip: false, logger: Rails.logger}]
  #   def full_filename for_file
  #     jpg_name for_file, version_name
  #   end
  # end
  # 
  # def jpg_name for_file, version_name
  #   %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.jpg}
  # end
  
  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end
  
end