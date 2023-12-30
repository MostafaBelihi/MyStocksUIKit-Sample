//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

// MARK: - Colors
struct AppColor {
	/* Config colors */
	// Color codes
	static private let backgroundSecondaryCode = "0D0D0D";
	static private let foregroundSecondaryCode = "ABBAD6";
	
	static private let numPositiveCode = "00FE19";
	static private let numNegativeCode = "FE0009";
	static private let chartFillCode = "731AF6";

	// Background
	static let viewBackgroundPrimary: UIColor = .black;
	static let viewBackgroundSecondary: UIColor = getColor(fromHex: backgroundSecondaryCode);
	static let indicatorBackgroundTransparent: UIColor = getColor(fromHex: "000000", alpha: 0);

	// Text
	static let textPrimary: UIColor = .white;
	static let textSecondary: UIColor = getColor(fromHex: foregroundSecondaryCode);

	// Text inputs

	
	// Tint
	static let tintPrimary: UIColor = .white;
	static let tintSecondary: UIColor = .gray;

	// Numeric figures
	static let numPositive: UIColor = getColor(fromHex: numPositiveCode);
	static let numNegative: UIColor = getColor(fromHex: numNegativeCode);
	static let chartFill: UIColor = getColor(fromHex: chartFillCode);

	// Special Colors

}

extension AppColor {
	/// Resolve color code.
	/// - Parameter hex: Color Hex value.
	/// - Parameter alpha: Color Hex value.
	static func getColor(fromHex hex:String, alpha: CGFloat = 1.0) -> UIColor {
		var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}
		
		if ((cString.count) != 6) {
			return UIColor.gray
		}
		
		var rgbValue: UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)
		
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: alpha
		)
	}
}
