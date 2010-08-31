maintainer       "Ternary Labs"
maintainer_email "cookbooks@ternarylabs.com"
license          "Apache 2.0"
description      "Deploys and configures Integrity"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.2"

%w{ git sqlite passenger_enterprise  }.each do |cb|
  depends cb
end
