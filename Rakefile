require "bundler/setup"
Bundler::GemHelper.install_tasks

require 'spec/rake/spectask'

<<<<<<< HEAD
  Echoe.new('github', '0.4.2') do |p|
    p.rubyforge_name = 'github'
    p.summary      = "The official `github` command line helper for simplifying your GitHub experience."
    p.description  = "The official `github` command line helper for simplifying your GitHub experience."
    p.url          = "http://github.com/"
    p.author       = ['Chris Wanstrath', 'Kevin Ballard', 'Scott Chacon', 'Dr Nic Williams']
    p.email        = "chris@ozmm.org"
    p.dependencies = [
      "text-format >=1.0.0",
      "highline ~>1.5.1"
    ]
  end

rescue LoadError => boom
  puts "You are missing a dependency required for meta-operations on this gem."
  puts "#{boom.to_s.capitalize}."
=======
Spec::Rake::SpecTask.new("spec") do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--color']
>>>>>>> fa149f475c3209ded38f97736eaf77bee26517aa
end

Spec::Rake::SpecTask.new("rcov_spec") do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--color']
  t.rcov = true
  t.rcov_opts = ['--exclude', '^spec,/gems/']
end

task :test => :spec

desc "Run specs as default activity"
task :default => :spec