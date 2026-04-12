class TemplateBase::OverrideGenerator < Rails::Generators::Base
  source_root TemplateBase::ROOT

  argument :paths, type: :array, banner: "path path"

  def copy_paths
    paths.each do |path|
      Dir.exist?(find_in_source_paths(path)) ? directory(path) : copy_file(path)
    end
  end
end
