Pod::Spec.new do |spec|
  spec.name = "DTCalendar"
  spec.version = "1.0.4"
  spec.summary = "Simple calendar control"
  spec.homepage = "https://github.com/danjiang/DTCalendar"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Dan Jiang" => 'dan@danthought.com' }
  spec.social_media_url = "http://twitter.com/dtstudio"

  spec.platform = :ios, "8.4"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/danjiang/DTCalendar.git", tag: spec.version, submodules: true }
  spec.source_files = "Sources/**/*.{h,swift}"
  spec.resources = "Sources/*.png"
end
