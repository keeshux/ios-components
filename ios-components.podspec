Pod::Spec.new do |s|
    s.name              = 'ios-components'
    s.version           = '1.2'
    s.license           = 'GPL'

    s.summary           = 'Collection of reusable components for iOS development.'

    s.homepage          = 'https://github.com/keeshux/ios-components'
    s.authors           = { 'Davide De Rosa' => 'keeshux@gmail.com' }
    s.source            = { :git => 'https://github.com/keeshux/ios-components.git',
                            :tag => s.version.to_s }

    s.platform          = :ios, '6.0'
    s.source_files      = 'Components/ARCHelper.h'
    s.exclude_files     = [ 'ComponentsDemo', 'ComponentsTests' ]
    s.requires_arc      = true

    s.subspec 'Macros' do |p|
        p.source_files  = ['Components/ARCHelper.h', 'Components/Macros/**/*.{h,m}']
    end

    s.subspec 'Utils' do |p|
        p.source_files  = ['Components/Utils/**/*.{h,m}']
        p.dependency 'ios-components/Macros'
    end

    s.subspec 'UI' do |p|
        p.source_files  = ['Components/UI/**/*.{h,m}']
        p.dependency 'ios-components/Macros'
    end

    s.subspec 'IAP' do |p|
        p.source_files  = ['Components/IAP/**/*.{h,m}']
        p.dependency 'ios-components/Macros'
        p.dependency 'ios-components/Utils'
    end
end
