namespace :render do
  desc "Renders an image with new proposed icons"
  task :new_icons => :environment do
    branch = `git rev-parse --abbrev-ref HEAD`

    puts `git diff master..#{branch}`
  end
end
