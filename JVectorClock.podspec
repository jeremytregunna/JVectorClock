Pod::Spec.new do |s|
  s.name = 'JVectorClock'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Vector clock implementation for iOS and Mac OS X'
  s.homepage = 'https://github.com/jeremytregunna/JVectorClock'
  s.authors = { 'Jeremy Tregunna' => 'jeremy@tregunna.ca' }
  s.source = { :git => 'https://github.com/jeremytregunna/JVectorClock.git', :tag => '1.0.0' }
  s.requires_arc = true
  s.source_files = "JVectorClock/JVectorClock.{h,m}"
  s.ios.deployment_target = '5.1'
  s.osx.deployment_target = '10.7'
end
