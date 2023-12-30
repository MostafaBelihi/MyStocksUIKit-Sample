//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import Moya

enum APIEndpoints {
	case data
	case quote(symbol: String)
	case companyProfile(symbol: String)
	case candle(symbol: String, resolution: String, dateFrom: Date, dateTo: Date)
	case companyNews(symbol: String, dateFrom: Date, dateTo: Date)
	case symbols(exchange: String)
}

extension APIEndpoints: TargetType {
	var baseURL: URL { URL(string: APIConstants.baseURL)! }

	var path: String {
		switch self {
			case .data: return "data";
			case .quote: return "quote";
			case .companyProfile: return "stock/profile2";
			case .candle: return "stock/candle";
			case .companyNews: return "company-news";
			case .symbols: return "stock/symbol";
		}
	}
	
	var method: Moya.Method {
		switch self {
			default: return .get;
		}
	}
	
	var task: Task {
		// Default parameters
		var parameters: Dictionary<String, Any> = ["token": APIConstants.apiToken];
		
		switch self {
			case .quote(let symbol), .companyProfile(let symbol):
				parameters["symbol"] = symbol;
				return .requestParameters(parameters: parameters as [String : Any], encoding: URLEncoding.queryString);
			
			case .candle(let symbol, let resolution, let dateFrom, let dateTo):
				parameters["symbol"] = symbol;
				parameters["resolution"] = resolution;
				parameters["from"] = Int(dateFrom.timeIntervalSince1970);
				parameters["to"] = Int(dateTo.timeIntervalSince1970);
				return .requestParameters(parameters: parameters as [String : Any], encoding: URLEncoding.queryString);
			
			case .companyNews(let symbol, let dateFrom, let dateTo):
				parameters["symbol"] = symbol;
				parameters["from"] = dateFrom.toString(format: "yyyy-MM-dd");
				parameters["to"] = dateTo.toString(format: "yyyy-MM-dd");
				return .requestParameters(parameters: parameters as [String : Any], encoding: URLEncoding.queryString);
				
			case .symbols(let exchange):
				parameters["exchange"] = exchange;
				return .requestParameters(parameters: parameters as [String : Any], encoding: URLEncoding.queryString);

			default:
				return .requestParameters(parameters: parameters as [String : Any], encoding: URLEncoding.queryString);
		}
	}

	var headers: [String: String]? {
		let headers: Dictionary<String, String> = ["Content-Type": "application/json"];
		return headers;
	}
	
}
