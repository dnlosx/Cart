
Pod::Spec.new do |s|
  s.name         = "Cart"
  s.version      = "0.0.4"
  s.summary      = "This project contains the basic needed to create a Shopping Cart in memory. It doesn't supports (and is not intended) persistence."
  s.homepage     = "https://github.com/dnlosx/Cart"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Daniel BR" => "dnlosx@gmail.com" }

  s.source       = { :git => "https://github.com/dnlosx/Cart.git", :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = "Sources/*.swift"
end
