//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

// MARK: - Fonts
struct AppFont {
	var size: CGFloat;
	var weight: UIFont.Weight;

	/// Constant collection of all app's font names per language and font weight
	let fontNames: [FontName] = [
		FontName(language: .english, weight: .light, name: "Quicksand-Light"),
		FontName(language: .english, weight: .regular, name: "Quicksand-Regular"),
		FontName(language: .english, weight: .medium, name: "Quicksand-Medium"),
		FontName(language: .english, weight: .semibold, name: "Quicksand-SemiBold"),
		FontName(language: .english, weight: .bold, name: "Quicksand-Bold")
	];

	struct FontName {
		var language: Language;
		var weight: UIFont.Weight;
		var name: String;
	}

	/// Get font name per language and font wight
	var fontName: String? {
		return fontNames.first(where: { $0.language == LocaleManager.language && $0.weight == weight })?.name;
	}
	
	/// Get UIFont from font data
	var font: UIFont {
		guard let fontName = fontName else {
			return defaultFont;
		}
		
		return UIFont(name: fontName, size: size) ?? defaultFont;
	}
	
	private var defaultFont: UIFont {
		return UIFont.systemFont(ofSize: size, weight: weight);
	}
}
