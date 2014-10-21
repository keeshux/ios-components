Pod::Spec.new do |s|
    s.name              = 'ios-components'
    s.version           = '1.1'
    s.license           = 'GPL'

    s.summary           = 'Collection of reusable components for iOS development.'

    s.homepage          = 'https://github.com/keeshux/ios-components'
    s.authors           = { 'Davide De Rosa' => 'keeshux@gmail.com' }
    s.source            = { :git => 'https://github.com/keeshux/ios-components.git',
                            :tag => s.version.to_s }

    s.platform          = :ios, '6.0'
    s.source_files      = 'Components/**/*.{h,m}'
    s.exclude_files     = [ 'ComponentsDemo', 'ComponentsTests' ]
    s.requires_arc      = true
end
