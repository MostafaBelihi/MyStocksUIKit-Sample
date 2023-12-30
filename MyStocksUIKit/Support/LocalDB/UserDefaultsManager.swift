//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

class UserDefaultsManager {
	private let defaults = UserDefaults.standard;
	
	func store<T: Codable>(_ item: T, usingKey key: String) {
		defaults.set(try? PropertyListEncoder().encode(item), forKey:key);
	}
	
	func retrieve<T: Codable>(usingKey key: String) -> T? {
		var restoredItem: T?;
		
		if let data = defaults.value(forKey: key) as? Data {
			restoredItem = try? PropertyListDecoder().decode(T.self, from: data);
		}
		
		return restoredItem;
	}
	
	func remove(usingKey key: String) {
		defaults.removeObject(forKey: key);
	}
}
