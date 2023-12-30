//
//  CompanyStock.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 04/08/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

struct CompanyStock {
	var symbol: String
	var name: String?
	var company: Company?
	var displayOrder: Int = 0
}
