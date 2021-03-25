Pod::Spec.new do |spec|
  spec.name             = 'WeScanKbs'
  spec.version          = '1.0.7'
  spec.summary          = 'Camera Lib - Document Scanning - iOS'
  spec.description      = 'WeScanKbs allows to take a photo and automatically scan data! It also allows using image gallery. Forked version of standard WeScan pod.'

  spec.homepage         = 'https://github.com/kbs-fabfel/WeScan'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors           = {
    'Fab Fel' => 'ff.knappschaft@gmail.com'
  }
  spec.source           = { :git => 'https://github.com/kbs-fabfel/WeScan.git', :tag => "#{spec.version}" }

  spec.swift_version = '5.0'
  spec.ios.deployment_target = '10.0'
  spec.source_files = 'WeScan/**/*.{h,m,swift}'
  spec.resource_bundle = { 'WeScan' => ['WeScan/**/*.{strings,png}'] }
end
