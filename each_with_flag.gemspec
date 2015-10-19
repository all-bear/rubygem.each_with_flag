require File.expand_path('../lib/each_with_flag/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'each_with_flag'
  s.version       = EachWithFlag::VERSION
  s.date          = '2015-10-18'
  s.summary       = 'Enhanced each methods (each with flags) for Enumerable objects'
  s.authors       = ['Oleh Birjukov']
  s.email         = 'ol.birjukov@gmail.com'
  s.files         = Dir['**/*'].reject { |f| f.include?('git') }
  s.homepage      = 'https://github.com/all-bear/rubygem.each-with-flag'
  s.license       = 'MIT'
  s.test_files    = s.files.grep(%r{^(test)/})
  s.require_paths = ['lib']
  s.description = <<-EOF
     The each-with-flag library provides Enumerable methods
     "each_with_flag" and "each_with_index_with_flag"
     that expand standard methods "each" and "each_with_index"
     adding to yield block flags of first, has previous, surrounded, has next and has last element.
  EOF

  s.add_dependency 'rake'
  s.add_development_dependency 'test-unit'
end