//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2020 Mostafa AlBelliehy. All rights reserved.
//

// Multi-Language Custom Solution
//
// Credit: https://stackoverflow.com/a/53442744/7128177

import Foundation
import UIKit

private var bundleKey: UInt8 = 0

final class BundleExtension: Bundle {
	override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
		return (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
	}
}

extension Bundle {
	static let once: Void = { object_setClass(Bundle.main, type(of: BundleExtension())) }()
	
	
	/// Set app language (switch language)
	/// - Parameter language: Language enum instance of new language.
	static func set(language: Language) {
		Bundle.once
		
		// Set UI direction
		let isLanguageRTL = Locale.characterDirection(forLanguage: language.code) == .rightToLeft
		UIView.appearance().semanticContentAttribute = (isLanguageRTL == true) ? .forceRightToLeft : .forceLeftToRight
		
		// Save language settings
		UserDefaults.standard.set(isLanguageRTL,   forKey: "AppleTe  zxtDirection")
		UserDefaults.standard.set(isLanguageRTL,   forKey: "NSForceRightToLeftWritingDirection")
		UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
		UserDefaults.standard.synchronize()
		
		// Switch app language
		guard let path = Bundle.main.path(forResource: language.code, ofType: "lproj") else {
			print("Failed to get a bundle path.")
			return
		}
		
		objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}
