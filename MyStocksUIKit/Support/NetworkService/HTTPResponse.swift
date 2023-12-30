//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import Alamofire

struct HTTPResponse<TModel, TError> {
	var result: Result<TModel, DataError<TError>>;
	var statusCode: Int;
	var headers: Alamofire.HTTPHeaders?;
}
