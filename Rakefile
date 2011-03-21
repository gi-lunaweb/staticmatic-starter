#change these values if you deploy with rsync
ssh_user      = "user@ip"    # for rsync deployment
remote_root = "/var/www/html/ path /" # for rsync deployment

source = "src"  #source directory (needed to auto-rebuild site on changes)

desc "Runs preview"
task :preview do
  system "staticmatic preview ."
end

desc "Builds the site"
task :build => 'styles:clear' do
  puts "*** Building the site ***"
  system "staticmatic build ."
  system "rake css_versioning"
  system "rake build_php"
end

desc "Converts includes in html files to php. Usage: %php_include page-to-include.php"
task :build_php do
  puts "*** Converting php includes ***"
  Dir[File.expand_path('../site/**/*.html', __FILE__)].each do |file|
    content = File.open(file).read
    if content.index '<php_include>'
      content = content.gsub(/<php_include>([^<]+)<\/php_include>/, '<?php include(\'../includes/\\1\'); ?>')
      File.open(file.gsub(/\.html$/, '.php'), 'w+').puts content
      File.unlink file
    end
  end
end

desc "Adds version query param to css. ie: application.css?1300696462"
task :css_versioning do
  puts "*** Adding css query params ***"
  Dir[File.expand_path('../site/**/*.html', __FILE__)].each do |file|
    content = File.open(file).read
    content = content.gsub(/application.css/, 'application.css?' + Time.now.to_i.to_s)
    File.open(file, 'w+').puts content
  end
end

desc "Clears and generates new styles, builds and deploys"
task :deploy => [:build, :push] do
  puts "*** Deploying the site ***"
  
end

desc "Archives the site to site/archive.tar.gz"
task :zip do
  puts "*** Archiving the site ***"
  system("rm site/archive.tar.gz")
  system("tar -czf archive.tar.gz site")
  system("mv archive.tar.gz site/")
end

desc "push"
task :push do
  system("rsync -avz --delete --exclude-from=.rsyncexclude site/ #{ssh_user}:#{remote_root}")
end

namespace :styles do
  desc "Clears the styles"
  task :clear do
    puts "*** Clearing styles ***"
    system "rm -Rfv site/stylesheets/*"
  end
  
  desc "Generates new styles"
  task :generate do
    puts "*** Generating styles ***"
    system "compass compile"
  end
  
end

def rebuild_site(relative)
  puts "\n\n>>> Change Detected to: #{relative} <<<"
  if (relative.include? ".sass") || (relative.include? ".scss")
    IO.popen('rake styles:generate'){|io| print(io.readpartial(512)) until io.eof?}
    puts '>>> Update Styles Complete <<<'
  else
    IO.popen('rake build'){|io| print(io.readpartial(512)) until io.eof?}
    puts '>>> Update Site Complete <<<'
  end
end

def rebuild_style(relative)
  puts "\n\n>>> Change Detected to: #{relative} <<<"
  IO.popen('rake styles:generate'){|io| print(io.readpartial(512)) until io.eof?}
  puts '>>> Update Complete <<<'
end

desc "Watch the site and regenerate when it changes"
task :watch do
  require 'fssm'
  puts ">>> Watching for Changes <<<"
  FSSM.monitor do
    path "#{File.dirname(__FILE__)}/#{source}" do
      update {|base, relative| rebuild_site(relative)}
      delete {|base, relative| rebuild_site(relative)}
      create {|base, relative| rebuild_site(relative)}
    end
  end
end