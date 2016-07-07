# encoding: utf-8
require 'carrierwave/processing/mini_magick'
class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # include RedactorRails::Backend::CarrierWave

  # storage :fog
  storage :file
  # storage :qiniu

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    #RedactorRails.document_file_types
    %w(jpg jpeg gif png zip apk ipa)
  end
end
