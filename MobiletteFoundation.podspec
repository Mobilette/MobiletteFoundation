Pod::Spec.new do |s|

	s.name		= "MobiletteFoundation"
	s.version		= "1.0.0"
	s.summary		= "A small set of necessary classes."

	s.license 		= { :type => "MIT", :file => "LICENSE" }

	s.author		= { "Romain Asnar" => "romain.asnar@gmail.com" }

	s.homepage		= "https://github.com/Mobilette/MobiletteFoundation"

	s.platform		= :ios
	s.platform		= :ios, "8.0"

	s.source 		= { :git => "https://github.com/Mobilette/MobiletteFoundation.git", :tag => s.version }


	s.source_files	= "Source/*.{swift}"

	s.framework		= "Foundation", "UIKit"
	s.dependency	"Alamofire"

	s.requires_arc	= true

end