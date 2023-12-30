//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import Moya

class RESTNetworkService<Endpoint: TargetType>: PNetworkService {
	
	// MARK: - Dependencies
	private var provider: MoyaProvider<Endpoint>;
	private var logger: Logging;
	private var dataCoder: PDataCoder;
	private var connection: Connectivity;
	
	// MARK: - More Variables
	let logErrorResponseTitle = "Error Response";
	let isEnabledProviderLogger = false;
	
	// MARK: - Init
	init(logger: Logging, dataCoder: PDataCoder, connection: Connectivity) {
		self.logger = logger;
		self.dataCoder = dataCoder;
		self.connection = connection;

		if (isEnabledProviderLogger) {
			self.provider = MoyaProvider<Endpoint>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))]);
		}
		else {
			self.provider = MoyaProvider<Endpoint>();
		}
	}
	
	// MARK: - Functions
	func request<TModel: Decodable, TError: Decodable>(_ request: Endpoint,
													   completion: @escaping HTTPResponseClosure<TModel, TError>) {
		
		//- Error Handling: No connection
		guard connection.isConnected else {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.noConnection.rawValue);
			let httpResponse = HTTPResponse<TModel, TError>(result: .failure(DataError(ofType: .noConnection)), statusCode: 0);
			completion(httpResponse);
			return;
		}

		logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: "Service Request", "\(request.baseURL)/\(request.path)");
		provider.request(request) { [weak self] result in
			switch result {
				case .success(let response):
					self?.successHandler(response: response, completion: completion);
					
				case .failure(let error):
					self?.moyaFailureHandler(error: error, completion: completion);
			}
		}
	}
	
	internal func successHandler<TModel: Decodable, TError: Decodable>(response: Response,
																	   completion: @escaping HTTPResponseClosure<TModel, TError>) {
		// Debug Prints
		logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: "successHandler", "Moya Success");
		logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: "Service Response", response);
		
		// Build response
		let statusCode = response.statusCode;
		let headers = response.response?.headers;
		
		// Handle Response
		switch statusCode {
			case 200..<299:
				// Decoding
				let model = dataCoder.decodeModel(ofType: TModel.self, from: response.data);
				
				if let model = model {
					let httpResponse = HTTPResponse<TModel, TError>(result: .success(model), statusCode: statusCode, headers: headers);
					completion(httpResponse);
				}
				else {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.decodingError.rawValue);
					let httpResponse = HTTPResponse<TModel, TError>(result: .failure(DataError(ofType: .decodingError)), statusCode: statusCode, headers: headers);
					completion(httpResponse);
				}
				
			case 401, 403:
				// Decoding
				logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.unauthorizedUser.rawValue);
				let model = dataCoder.decodeModel(ofType: TError.self, from: response.data);
				
				if let model = model {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logErrorResponseTitle, model);
					let httpResponse = HTTPResponse<TModel, TError>(result: .failure(DataError(ofType: .unauthorizedUser, error: model)), statusCode: statusCode, headers: headers);
					completion(httpResponse);
				}
				else {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.decodingError.rawValue);
					let httpResponse = HTTPResponse<TModel, TError>(result: .failure(DataError(ofType: .decodingError)), statusCode: statusCode, headers: headers);
					completion(httpResponse);
				}
				
			case 404:
				logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.invalidEndpoint.rawValue);
				let httpResponse = HTTPResponse<TModel, TError>(result: .failure(DataError(ofType: .invalidEndpoint)), statusCode: statusCode, headers: headers);
				completion(httpResponse);
				
			default:
				//- Error Handling: No connection
				guard connection.isConnected else {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.noConnection.rawValue);
					let httpResponse = HTTPResponse<TModel, TError>(result: .failure(DataError(ofType: .noConnection)), statusCode: 0);
					completion(httpResponse);
					return;
				}

				// Decoding
				logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.serviceError.rawValue);
				let model = dataCoder.decodeModel(ofType: TError.self, from: response.data);
				
				if let model = model {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logErrorResponseTitle, model);
					let httpResponse = HTTPResponse<TModel, TError>(result: .failure(DataError(ofType: .serviceError, error: model)), statusCode: statusCode, headers: headers);
					completion(httpResponse);
				}
				else {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.decodingError.rawValue);
					let httpResponse = HTTPResponse<TModel, TError>(result: .failure(DataError(ofType: .decodingError)), statusCode: statusCode, headers: headers);
					completion(httpResponse);
				}
		}
		
	}
	
	// TODO: Temp handling of Moya Error
	internal func moyaFailureHandler<TModel: Decodable, TError: Decodable>(error: MoyaError,
																		   completion: @escaping HTTPResponseClosure<TModel, TError>) {
		// Debug Prints
		logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: "moyaFailureHandler", "Moya Failure");
		logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: "Moya Error", error);
		
		//- Error Handling: No connection
		guard connection.isConnected else {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.noConnection.rawValue);
			let httpResponse = HTTPResponse<TModel, TError>(result: .failure(DataError(ofType: .noConnection)), statusCode: 0);
			completion(httpResponse);
			return;
		}

		// Response
		let httpResponse = HTTPResponse<TModel, TError>(result: .failure(DataError(ofType: .moyaFailure)), statusCode: 0, headers: .none);
		completion(httpResponse);
	}
}
