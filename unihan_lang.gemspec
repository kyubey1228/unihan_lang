require_relative 'lib/unihan_lang/version'

Gem::Specification.new do |spec|
  spec.name          = "unihan_lang"
  spec.version       = UnihanLang::VERSION
  spec.authors       = ["kyubey1228"]
  spec.email         = ["kyuuka1228@gmail.com"]

  spec.summary       = %q{Language detection for Chinese and Japanese characters}
  spec.description   = %q{A gem to detect and differentiate between Traditional Chinese, Simplified Chinese, and Japanese characters based on Unihan data.}
  spec.homepage      = "https://github.com/kyubey1228/unihan_lang"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end + Dir['data/*']
end
