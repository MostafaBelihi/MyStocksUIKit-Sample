//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

// Credit: https://stackoverflow.com/a/53006873/7128177

import UIKit

enum DeviceTrait {
	case wRhR
	case wChR
	case wRhC
	case wChC
	
	static var screenTrait: DeviceTrait {
		switch (UIScreen.main.traitCollection.horizontalSizeClass, UIScreen.main.traitCollection.verticalSizeClass) {
			case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular):
				return .wRhR
			
			case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.regular):
				return .wChR
			
			case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.compact):
				return .wRhC
			
			case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.compact):
				return .wChC
			
			default:
				return .wChR
		}
	}

	static var windowTrait: DeviceTrait {
		guard let window = AppDelegate.shared.window else {
			fatalError("Unexpectedly did not find an app window!!!");
		}
		
		switch (window.traitCollection.horizontalSizeClass, window.traitCollection.verticalSizeClass) {
			case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular):
				return .wRhR
				
			case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.regular):
				return .wChR
				
			case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.compact):
				return .wRhC
				
			case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.compact):
				return .wChC
				
			default:
				return .wChR
		}
	}
	
	static var isLargeWindow: Bool {
		return DeviceTrait.windowTrait == .wRhR;
	}
	
	static var isPad: Bool {
		return UIDevice.current.userInterfaceIdiom == .pad;
	}
}
