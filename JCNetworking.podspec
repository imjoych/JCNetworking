Pod::Spec.new do |s|

  s.name         = 'JCNetworking'
  s.version      = '0.0.1'
  s.license      = 'MIT'
  s.summary      = 'A useful iOS networking framework based on AFNetworking and JSONModel.'
  s.homepage     = 'https://github.com/boych/JCNetworking'
  s.author       = { 'boych' => 'ioschen@foxmail.com' }
  s.source        = { :git => 'https://github.com/boych/JCNetworking.git', :tag => s.version.to_s }
  s.source_files  = 'JCNetworking/*.{h,m}'
  s.platform      = :ios, '8.0'
  s.requires_arc  = true
  s.public_header_files = 'JCNetworking/JCNetworking.h'

  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'JSONModel', '~> 1.2.0'

end
