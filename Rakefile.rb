require 'rake'

desc "Dotfiles instalation"
task :install do
  puts "installing dotfiles. creating (symlinks)."

  skip_all = false
  overwrite_all = false
  backup_all = false

  zshthemes = Dir.glob('*/**{.zsh-theme}')
  zshlinkables = Dir.glob('*/**{.zsh}')
  linkables = Dir.glob('*/**{.symlink}')

  linkables.each do |linkable|
    overwrite = false
    backup = false

    file = linkable.split('/').last.split('.symlink').last
    target_linkable = "#{ENV["HOME"]}/.#{file}"

    if File.exists?(target_linkable) || File.symlink?(target_linkable)
      unless skip_all || overwrite_all || backup_all
        puts "File already exists: #{target_linkable}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then skip_all = true
        when 's' then next
        end
      end
      FileUtils.rm_rf(target_linkable) if overwrite || overwrite_all
      `mv "$HOME/.#{file}" "$HOME/.#{file}.backup"` if backup || backup_all
    end
    `ln -s "$PWD/#{linkable}" "#{target_linkable}"`
  end

  zshlinkables.each do |zshlinkable|
    file = zshlinkable.split('/').last
    target_zshlinkable = "#{ENV["HOME"]}/.oh-my-zsh/custom/#{file}"

    if File.exists?(target_zshlinkable) || File.symlink?(target_zshlinkable)
      unless skip_all || overwrite_all || backup_all
        puts "File already exists: #{target_zshlinkable}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then skip_all = true
        when 's' then next
        end
      end
      FileUtils.rm_rf(target_zshlinkable) if overwrite || overwrite_all
      `mv "$HOME/.#{file}" "$HOME/.#{file}.backup"` if backup || backup_all
    end
    `ln -s "$PWD/#{zshlinkable}" "#{target_zshlinkable}"`
  end

  zshthemes.each do |zshtheme|
    file = zshtheme.split('/').last
    target_zshtheme = "#{ENV["HOME"]}/.oh-my-zsh/custom/#{file}"

    if File.exists?(target_zshtheme) || File.symlink?(target_zshtheme)
      unless skip_all || overwrite_all || backup_all
        puts "File already exists: #{target_zshtheme}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then skip_all = true
        when 's' then next
        end
      end
      FileUtils.rm_rf(target_zshtheme) if overwrite || overwrite_all
      `mv "$HOME/.#{file}" "$HOME/.#{file}.backup"` if backup || backup_all
    end
    `ln -s "$PWD/#{zshtheme}" "#{target_zshtheme}"`
  end
end

task :uninstall do

  Dir.glob('**/*.symlink').each do |linkable|

    file = linkable.split('/').last.split('.symlink').last
    target_linkable = "#{ENV["HOME"]}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target_linkable)
      FileUtils.rm(target_linkable)
    end

    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"`
    end

  end

  Dir.glob('**/*.zsh').each do |zshlinkable|

    file = zshlinkable.split('/').last
    target_zshlinkable = "#{ENV["HOME"]}/.oh-my-zsh/custom/#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target_zshlinkable)
      FileUtils.rm(target_zshlinkable)
    end

    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"`
    end

  end

  Dir.glob('**/*.zsh-theme').each do |zshtheme|

    file = zshtheme.split('/').last
    target_zshtheme = "#{ENV["HOME"]}/.oh-my-zsh/custom/#{file}"


    # Remove all symlinks created during installation
    if File.symlink?(target_zshtheme)
      FileUtils.rm(target_zshtheme)
    end

    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"`
    end

  end
end

desc "Check for homebrew existence"
task :check_for_homebrew do
  puts "checking for hombrew existence"
  apps = %w[git rbenv ruby-build coreutils node mysql macvim libyaml wget tree ssh-copy-id python]
  brew = system %Q{which brew}
  if (brew == true)
    puts "Hombrew is already installed."
    print "Remember to install the following apps:"
    apps.each do |app|
      print " #{app}"
    end
  else
    system %Q{ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"}
  end
end

def export_rbenv
  puts "hola"
end

desc "Change shell"
task :change_shell do
  if ENV["SHELL"] =~ /zsh/
    puts "Already using zsh"
  else
    puts "changing the default shell to zsh"
    system %Q{chsh -s `which zsh`}
  end
end

