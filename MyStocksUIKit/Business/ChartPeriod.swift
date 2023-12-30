//
//  ChartPeriod.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 13/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

/// Represents time ranges needed to stock history charts.
enum ChartPeriod: Int {
	case week = 7
	case month = 30
	case year = 365
}
