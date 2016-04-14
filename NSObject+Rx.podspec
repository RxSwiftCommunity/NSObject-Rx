Pod::Spec.new do |s|
  s.name         = "NSObject+Rx"
  s.version      = "1.2.1"
  s.summary      = "Handy RxSwift extensions on NSObject."
  s.description  = <<-DESC
    Right now, we just have a `rx_disposeBag` property, but we're open to PRs!
                   DESC
  s.homepage     = "https://github.com/RxSwiftCommunity/NSObject-Rx"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Ash Furrow" => "ash@ashfurrow.com" }
  s.social_media_url   = "http://twitter.com/ashfurrow"

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/RxSwiftCommunity/NSObject-Rx.git", :tag => s.version }
  s.source_files  = "*.{swift,h,m}"
  s.frameworks  = "Foundation"
  s.dependency "RxSwift", '~> 2.1'
  s.dependency 'RxCocoa', '~> 2.1'
end
