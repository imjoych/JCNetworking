Pod::Spec.new do |s|
  s.name         = 'JCNetworking'
  s.version      = '1.0.2'
  s.summary      = 'A lightweight iOS networking framework based on AFNetworking and JSONModel.'
  s.homepage     = 'https://github.com/imjoych/JCNetworking'
  s.author       = { 'ChenJianjun' => 'imjoych@gmail.com' }
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.source       = { :git => 'https://github.com/imjoych/JCNetworking.git', :tag => s.version.to_s }
  s.source_files = 'JCNetworking/*.{h,m}'
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'JSONModel', '~> 1.2.0'

end
