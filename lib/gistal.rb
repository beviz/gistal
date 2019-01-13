require 'yaml'
require 'json'
require 'pathname'

class Gistal
  def initialize(config_fielname)
    load_config(config_fielname)
  end

  def load_config(filename)
    @config = YAML.load_file(filename)
    @home_path = File.dirname(filename)
    @lock = File.join(@home_path, 'gistr.lock')
  end

  def parse
    @config['gists'].each do |item|
      gist_result = get_gist(item)

      item['files'].each do |file_config|
        gist_file = gist_result['files'][file_config['source']]

        dest_filename = file_config['name'] || gist_file['filename']
        dest_folder   = file_config['dest'] || item['dest'] || item['id']

        dest_fullpath = File.join(@home_path, dest_folder, dest_filename)

        write_content(file_config['source'], dest_fullpath, gist_file['raw_url'])
        chmod(dest_fullpath, file_config['chmod'])
      end
    end
  end

  def get_gist(config)
    puts "Processing [#{config['name']}](#{config['id']})"
    JSON.parse `curl -s https://api.github.com/gists/#{config['id']}`
  end

  def write_content(source, fullpath, content_url)
    puts "- saving #{source} => #{get_relative_path(fullpath)}"
    `curl -s #{content_url} --create-dirs -o "#{fullpath}"`
  end

  def chmod(fullpath, mod)
    return if mod.nil? || mod.empty?

    puts "- changing #{File.basename(fullpath)} => #{mod}"
    `chmod #{mod} "#{fullpath}"`
  end

  def get_relative_path(first, second = @home_path)
    Pathname.new(first).relative_path_from(Pathname.new(second))
  end
end
