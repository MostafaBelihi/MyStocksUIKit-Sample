//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2020 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

struct APIConstants {
	// MARK: - API
	static let baseDomain = "https://finnhub.io";
	static let baseURL = "\(APIConstants.baseDomain)/api/v1";
	static let apiToken = "xxx";

	// MARK: - General Constants
	// Stock candle frequency
	enum CandleResolution: String {
		case min1 = "1"
		case min5 = "5"
		case min15 = "15"
		case min30 = "30"
		case min60 = "60"
		case day = "D"
		case week = "W"
		case month = "M"
	}
	
	// JSON decoder and encoder
	static let jsonDecoder = JSONDecoder();
	static let jsonEncoder = JSONEncoder();

}
