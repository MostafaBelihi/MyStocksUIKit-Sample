//
//  APICompanyProfile.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 23/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

class APICompanyProfile: Codable {
	var country: String
	var currency: String
	var exchange: String
	var ipo: String
	var logo: String
	var marketCapitalization: Float
	var name: String
	var phone: String
	var shareOutstanding: Float
	var ticker: String
	var weburl: String
}
