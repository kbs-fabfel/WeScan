Pod::Spec.new do |spec|
  spec.name             = 'WeScan'
  spec.version          = '1.7.2'
  spec.summary          = 'Document Scanning Made Easy for iOS'
  spec.description      = 'WeScan makes it easy to add scanning functionalities to your iOS app! It\'s modelled after UIImagePickerController, which makes it a breeze to use.'

  spec.homepage         = 'https://github.com/kbs-fabfel/WeScan'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }

  spec.source           = { :git => 'https://github.com/kbs-fabfel/WeScan.git', :branch => "dev" }
  spec.social_media_url = 'https://twitter.com/WeTransfer'
  spec.authors           = {
      'Boris Emorine' => 'boris@wetransfer.com',
      'Antoine van der Lee' => 'antoine@wetransfer.com'
    }


  spec.swift_version = '5.0'
  spec.ios.deployment_target = '11.0'
  spec.source_files = 'WeScan/**/*.{h,m,swift}'
  spec.resources = 'WeScan/**/*.{strings,png}'
end
