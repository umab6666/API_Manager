
Pod::Spec.new do |s|

  s.name         = "ApiManager"
  s.version      = "1.0.0"
  s.summary      = "A short description of ApiManager."

  s.description  = "A short description of ApiManager upload download and request calls"
  s.homepage     = "http://EXAMPLE/ApiManager"
  s.license      = "MIT"

  s.author             = { "mohnish" => "vmohnish@thisisswitch.com" }

  s.platform     = :ios,"12.0"

  s.source       = { :git => "https://github.com/umab6666/API_Manager.git", :tag => "1.0.0" }

  s.source_files  = "ApiManager"


end
