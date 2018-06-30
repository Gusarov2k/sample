class PictureUploader < CarrierWave::Uploader::Base
storage :file
# Переопределяет каталог для выгруженных файлов.
# Есть смысл оставить значение по умолчанию, чтобы не приходилось настраивать загрузчики
def store_dir
"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
end
# Белый список поддерживаемых расширений имен файлов.
def extension_white_list
%w(jpg jpeg gif png)
end
end
