//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2020 Mostafa AlBelliehy. All rights reserved.
//

// Multi-Language Custom Solution
//
// Credit: https://stackoverflow.com/a/53442744/7128177

import Foundation

struct LocaleManager {
	/// Gets 2-letter language code for current language → "en", "ar"
	static var languageCode: String? {
		guard var splits = Locale.preferredLanguages.first?.split(separator: "-"), let first = splits.first else { return nil }
		guard 1 < splits.count else { return String(first) }
		splits.removeLast()
		return String(splits.joined(separator: "-"))
	}
	
	/// Gets Language enum instance for current language
	static var language: Language? {
		return Language(languageCode: languageCode)
	}
	
	/// Returns boolean value for whether current language is RTL or not
	static var isRightToLeft: Bool {
		return Locale.characterDirection(forLanguage: languageCode!) == .rightToLeft;
	}
}
