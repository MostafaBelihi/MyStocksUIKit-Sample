//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
	func load(_ urlString: String) {
		if let url = URL(string: urlString) {
			let request = URLRequest(url: url)
			load(request)
		}
	}
}
