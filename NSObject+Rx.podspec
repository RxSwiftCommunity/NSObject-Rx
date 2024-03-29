Pod::Spec.new do |s|
  s.name         = "NSObject+Rx"
  s.version      = "5.2.2"
  s.summary      = "Handy RxSwift extensions on NSObject."
  s.description  = <<-DESC
    Right now, we just have a `rx_disposeBag` property, but we're open to PRs!
                   DESC
  s.homepage     = "https://github.com/RxSwiftCommunity/NSObject-Rx"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Ash Furrow" => "ash@ashfurrow.com" }
  s.social_media_url   = "https://twitter.com/ashfurrow"

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '3.0'
  s.tvos.deployment_target = '9.0'

  s.swift_version = '5.2'
  s.source       = { :git => "https://github.com/RxSwiftCommunity/NSObject-Rx.git", :tag => s.version }
  s.source_files  = %w(NSObject+Rx.swift HasDisposeBag.swift)
  s.frameworks  = "Foundation"
  s.dependency 'RxSwift', '~> 6.2'
end
