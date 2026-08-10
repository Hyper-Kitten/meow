# frozen_string_literal: true

namespace :meow do
  namespace :icons do
    LUCIDE_VERSION = "1.31.0"
    LUCIDE_DIR = File.expand_path("../lib/hyper_kitten_meow/icons", __dir__)

    desc "Vendor the lucide icon set into lib/hyper_kitten_meow/icons (override with VERSION=)"
    task :sync do
      require "fileutils"
      require "tmpdir"

      version = ENV.fetch("VERSION", LUCIDE_VERSION)
      url = "https://registry.npmjs.org/lucide-static/-/lucide-static-#{version}.tgz"

      Dir.mktmpdir do |tmp|
        tarball = File.join(tmp, "lucide.tgz")

        abort "failed to download #{url}" unless system("curl", "-sfL", url, "-o", tarball)
        abort "failed to unpack #{tarball}" unless system(
          "tar", "xzf", tarball, "-C", tmp, "package/icons", "package/LICENSE",
          out: File::NULL, err: File::NULL
        )

        sources = Dir[File.join(tmp, "package/icons/*.svg")].sort
        abort "no icons found in lucide-static #{version}" if sources.empty?

        FileUtils.rm_rf(LUCIDE_DIR)
        FileUtils.mkdir_p(LUCIDE_DIR)

        sources.each do |source|
          svg = File.read(source)
          license = svg[/\A<!--.*?-->/m]
          body = svg.sub(/\A<!--.*?-->\s*/m, "").gsub(/\s+/, " ").gsub(/ (\/?>)/, '\1').strip

          File.write(File.join(LUCIDE_DIR, File.basename(source)), "#{license}\n#{body}\n")
        end

        FileUtils.cp(File.join(tmp, "package/LICENSE"), File.join(LUCIDE_DIR, "LICENSE"))

        kb = sources.sum { |s| File.size(File.join(LUCIDE_DIR, File.basename(s))) } / 1024
        puts "vendored #{sources.size} lucide v#{version} icons (#{kb} KB) into #{LUCIDE_DIR}"
      end
    end
  end
end
