Pod::Spec.new do |s|
  s.name             = 'CBMDTabbarController'
  s.version          = '1.0.0'
  s.summary          = 'It is a smooth MD tabbarController used on iOS, which implement by Swift.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/cbangchen/CBMDTabbarController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cbangchen007' => 'cbangchen007@gmail.com' }
  s.source           = { :git => 'https://github.com/cbangchen/CBMDTabbarController.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'CBMDTabbarController/Classes/**/*'
  s.resources = 'CBMDTabbarController/CBMDTabbarController.bundle'

end
