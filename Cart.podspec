
Pod::Spec.new do |s|
  s.name         = "Cart"
  s.version      = "0.0.1"
  s.summary      = "This project contains the basic needed to create a Shopping Cart in memory. It doesn't supports (and is not intended) persistence."
  s.homepage     = "https://github.com/dnlosx/Cart"
  s.license      = "MIT"
  s.author       = { "Daniel BR" => "dnlosx@gmail.com" }

  s.source       = { :git => "https://github.com/dnlosx/Cart.git", :tag => s.version }

  s.source_files = "Sources/*.swift"
end
