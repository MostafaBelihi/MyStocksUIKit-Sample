//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

// MARK: - Standard Text Styles
enum TextStyle {
	case tiny
	case small
	case normal
	case medium
	case big
	case large

	var fontSize: CGFloat {
		switch self {
			case .tiny: return !DeviceTrait.isLargeWindow ? 10 : 15;
			case .small: return !DeviceTrait.isLargeWindow ? 15 : 20;
			case .normal: return !DeviceTrait.isLargeWindow ? 18 : 23;
			case .medium: return !DeviceTrait.isLargeWindow ? 20 : 25;
			case .big: return !DeviceTrait.isLargeWindow ? 25 : 30;
			case .large: return !DeviceTrait.isLargeWindow ? 30 : 35;
		}
	}
	
	var fontWeight: UIFont.Weight {
		switch self {
			case .tiny,
				 .small,
				 .normal: return .regular;

			case .medium,
				 .big: return .semibold;

			case .large: return .bold;

		}
	}
	
	var font: UIFont {
		return AppFont(size: fontSize, weight: fontWeight).font;
	}
}

// MARK: - Sizes
struct AppSizes {

}
