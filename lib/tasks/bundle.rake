JS_DIR = File.join(File.dirname(__FILE__), '..', '..', 'public', 'js')
CSS_DIR = File.join(File.dirname(__FILE__), '..', '..', 'public', 'css')

CLOSURE_PATH = File.join(File.dirname(__FILE__), '..', 'closure-compressor.jar' )
YUI_PATH = File.join(File.dirname(__FILE__), '..', 'yui-compressor.jar' )

namespace :bundle do
  desc "Bundle JS and CSS"
  task :all => [ :js, :css ]

  desc "Bundle JS"
  task :js do
    paths = get_top_level_directories( JS_DIR )
    
    paths.each do |bundle_directory|
      bundle_name = bundle_directory.gsub( JS_DIR + '/', "" )
      files = recursive_file_list( bundle_directory, ".js" )
      next if files.empty? || bundle_name == 'dev'
      
      target = JS_DIR + "/bundle_#{bundle_name}.js"
      `java -jar #{CLOSURE_PATH} --js #{files.join(" --js ")} --js_output_file #{target} 2> /dev/null`

      puts "=> bundled js at #{target}"
    end
  end

  desc "Bundle CSS"
  task :css do
    paths = get_top_level_directories( CSS_DIR )

    paths.each do |bundle_directory|
      bundle_name = bundle_directory.gsub( CSS_DIR + '/', "" )
      files = recursive_file_list( bundle_directory, ".css" )
      next if files.empty? || bundle_name == 'dev'

      bundle = ''
      files.each do |file_path|
        bundle << File.read(file_path) << "\n"
      end

      target = CSS_DIR + "/bundle_#{bundle_name}.css"
      rawpath = "/tmp/bundle_raw.css"
      File.open(rawpath, 'w') { |f| f.write(bundle) }
      `java -jar #{YUI_PATH} --line-break 0 #{rawpath} -o #{target}`

      puts "=> bundled css at #{target}"
    end
  end

  require 'find'
  def recursive_file_list(basedir, ext)
    files = []
    Find.find(basedir) do |path|
      if FileTest.directory?(path)
        if File.basename(path)[0] == ?. # Skip dot directories
          Find.prune
        else
          next
        end
      end
      files << path if File.extname(path) == ext
    end
    files.sort
  end

  def get_top_level_directories(base_path)
    Dir.entries(base_path).collect do |path|
      path = "#{base_path}/#{path}"
      File.basename(path)[0] == ?. || !File.directory?(path) ? nil : path # not dot directories or files
    end - [nil]
  end
end