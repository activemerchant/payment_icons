namespace :render do
  desc "Renders an image with new proposed icons"
  task :new_icons => :environment do
    branch = `git rev-parse --abbrev-ref HEAD`.strip
    main_branch = `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`.strip
    svgs = `git diff --name-only #{main_branch}..#{branch} | grep svg`

    puts "----"
    puts svgs

  end
end
