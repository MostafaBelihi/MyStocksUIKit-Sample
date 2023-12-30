//
//  ChartsDateValueFormatters.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 13/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import Charts

public class DateValueFormatter: NSObject, AxisValueFormatter {
	let dateFormatter = DateFormatter()
	
	override init() {
		super.init()
		dateFormatter.dateFormat = "dd MMM HH:mm";
	}
	
	public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
		return dateFormatter.string(from: Date(timeIntervalSince1970: value));
	}
}

public class WeekDateValueFormatter: DateValueFormatter {
	override init() {
		super.init()
		dateFormatter.dateFormat = ViewConstants.chartWeekDateFormat;
	}
}

public class MonthDateValueFormatter: DateValueFormatter {
	override init() {
		super.init()
		dateFormatter.dateFormat = ViewConstants.chartMonthDateFormat;
	}
}

public class YearDateValueFormatter: DateValueFormatter {
	override init() {
		super.init()
		dateFormatter.dateFormat = ViewConstants.chartYearDateFormat;
	}
}
