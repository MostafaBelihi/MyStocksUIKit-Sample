//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PNetworkService {
	typealias HTTPResponseClosure<TModel: Decodable, TError: Decodable> = (HTTPResponse<TModel, TError>) -> Void;
	associatedtype RequestType;
	func request<TModel: Decodable, TError: Decodable>(_ request: RequestType,
													   completion: @escaping HTTPResponseClosure<TModel, TError>);
}
