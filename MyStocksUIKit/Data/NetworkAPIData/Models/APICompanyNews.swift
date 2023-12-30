//
//  APICompanyNews.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 30/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

struct APICompanyNews: Codable {
	let category: String
	let datetime: Int
	let headline: String
	let id: Int
	let image: String
	let related: String
	let source: String
	let summary: String
	let url: String
}
