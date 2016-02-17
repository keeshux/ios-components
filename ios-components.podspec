Pod::Spec.new do |s|
    s.name              = 'ios-components'
    s.version           = '1.3'
    s.license           = 'GPL'

    s.summary           = 'Collection of reusable components for iOS development.'

    s.homepage          = 'https://github.com/keeshux/ios-components'
    s.authors           = { 'Davide De Rosa' => 'keeshux@gmail.com' }
    s.source            = { :git => 'https://github.com/keeshux/ios-components.git',
                            :tag => s.version.to_s }

    s.platform          = :ios, '6.0'
    s.exclude_files     = [ 'ComponentsDemo', 'ComponentsTests' ]
    s.requires_arc      = true

    s.subspec 'Macros' do |p|
        p.source_files  = ['Components/Macros/**/*.{h,m}']
    end

    s.subspec 'Utils' do |p|
        p.source_files  = ['Components/Utils/**/*.{h,m}']
        p.dependency 'ios-components/Macros'
    end

    s.subspec 'UI' do |p|
        p.source_files  = ['Components/UI/**/*.{h,m}']
        p.frameworks    = ['CoreGraphics', 'CoreLocation', 'MapKit']
        p.dependency 'ios-components/Macros'
    end

    s.subspec 'IAP' do |p|
        p.source_files  = ['Components/IAP/**/*.{h,m}']
        p.frameworks    = ['Security', 'StoreKit']
        p.dependency 'ios-components/Macros'
        p.dependency 'ios-components/Utils'
    end

    s.subspec 'ProgressDownloader' do |p|
        p.source_files  = ['Components/ProgressDownloader/**/*.{h,m}']
        p.dependency 'ios-components/Macros'
        p.dependency 'MBProgressHUD'
    end
end
