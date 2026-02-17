namespace :lint do
  LINT_EXPECTED_PATTERNS = [
    %r{\Aapp/assets/images/payment_icons/.*\.svg\z},
    %r{\Adb/payment_icons\.yml\z},
    %r{\A(CONTRIBUTING|README|CHANGELOG|LICENSE)},
  ].freeze

  desc "Check that changed files are within the expected scope for icon contributions"
  task :file_scope do
    changed = changed_files_for_lint
    if changed.empty?
      puts "No changed files to check."
    else
      unexpected = changed.reject { |f| LINT_EXPECTED_PATTERNS.any? { |p| f.match?(p) } }

      if unexpected.any?
        puts "WARNING: #{unexpected.length} file(s) outside expected icon contribution scope:"
        unexpected.each { |f| puts "  #{f}" }
        puts "\nExpected: SVGs in app/assets/images/payment_icons/, db/payment_icons.yml, and documentation."
        puts "If these changes are intentional, a maintainer will review them."
      else
        puts "All #{changed.length} changed file(s) are within expected scope."
      end
    end
  end

  def changed_files_for_lint
    # CI: use CHANGED_FILES env var if provided (e.g. from gh pr diff --name-only)
    if ENV['CHANGED_FILES']
      return ENV['CHANGED_FILES'].split("\n").reject(&:empty?)
    end

    # Local: detect changes via git
    files = []

    # Committed changes vs origin/master (for feature branches)
    merge_base = `git merge-base HEAD origin/master 2>/dev/null`.strip
    unless merge_base.empty?
      committed = `git diff --name-only #{merge_base}...HEAD 2>/dev/null`.strip
      files.concat(committed.split("\n"))
    end

    # Uncommitted changes (staged + unstaged + untracked)
    files.concat(`git diff --name-only --cached 2>/dev/null`.strip.split("\n"))
    files.concat(`git diff --name-only 2>/dev/null`.strip.split("\n"))
    files.concat(`git ls-files --others --exclude-standard 2>/dev/null`.strip.split("\n"))

    files.uniq.reject(&:empty?)
  end
end
