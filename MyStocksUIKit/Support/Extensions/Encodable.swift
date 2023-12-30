//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

extension Encodable {
	var dictionary : [String: Any]? {
		let dataCoder = AppDelegate.di.container.resolve(PDataCoder.self)!;
		guard let data = dataCoder.encodeData(from: self) else { return nil }
		guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
		return json
	}
}
