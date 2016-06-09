Pod::Spec.new do |s|
  s.name         = 'JCNetworking'
  s.version      = '0.0.2'
  s.license      = 'MIT'
  s.summary      = 'A useful iOS networking framework based on AFNetworking and JSONModel.'
  s.homepage     = 'https://github.com/boych/JCNetworking'
  s.author       = { 'ChenJianjun' => 'ioschen@foxmail.com' }
  s.source       = { :git => 'https://github.com/boych/JCNetworking.git', :tag => s.version.to_s }
  s.source_files = 'JCNetworking/*.{h,m}'
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.subspec "JCDownloader" do |ss|
    ss.source_files = "JCNetworking/JCDownloader/*.{h,m}"
  end

  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'JSONModel', '~> 1.2.0'

end
