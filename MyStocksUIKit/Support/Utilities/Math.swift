//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

struct Math {
	/// Gets average of an array
	static func average<C: Collection>(of array: C) -> Double where C.Element == Int {
		precondition(!array.isEmpty, "Cannot compute average of empty collection");
		return Double(array.reduce(0, +)) / Double(array.count);
	}
	
	/// Rounds a number to decimal points
	static func round(number: Double, decimalPoints: Int) -> Double {
		var pointsValue = 1.0;
		
		for _ in 1...decimalPoints {
			pointsValue = pointsValue * 10;
		}
		
		return (number * pointsValue).rounded(.toNearestOrEven) / pointsValue;
	}
	
	/// Gets a formatted string from a money number to be like "1.1M" or "$5B".
	/// - Parameter number: The number to be formatted.
	/// - Parameter withThousandSeparators: If to add separator between every three digits. Default is true.
	/// - Parameter originalNumberFactor: The number factor of the provided number like 1K, 1M, 1B, etc. Default is .none.
	/// - Parameter newNumberFactor: The desired number factor of the output number string like 1K, 1M, 1B, etc. Default is .none.
	/// - Parameter currency: Currency of the provided number, to be included in the output string.  Default is .none.
	/// - Parameter shouldGetCurrencySymbol: If to include currency symbol, if available, like "$", instead of the regular currency code, like "USD". Default is false.
	/// - Returns: The formatted string of the money number.
	static func formatMoneyNumber(number: Double,
								  withThousandSeparators: Bool = true,
								  originalNumberFactor: NumberFactor = .none,
								  newNumberFactor: NumberFactor = .none,
								  currency: Currency = .none,
								  shouldGetCurrencySymbol: Bool = false) -> String {
		
		let rawNumber = newNumberFactor.getRawNumber(number: number, originalNumberFactor: originalNumberFactor);
		let finalNumber = Math.round(number: newNumberFactor.getFactoredNumber(rawNumber: rawNumber, originalNumberFactor: originalNumberFactor),
									 decimalPoints: 2);
		let factorSymbol = (newNumberFactor == .auto) ? newNumberFactor.getNumberFactorSymbol(rawNumber: rawNumber) : newNumberFactor.symbol;
		
		// String values
		var stringNumber = String(finalNumber);		// final string to return
		let decimalSides = stringNumber.components(separatedBy: ".");	// split with decimal points
		var integerSide = "0";
		var decimalSide = "0";
		
		if (decimalSides.count == 2) {
			integerSide = decimalSides[0];
			decimalSide = decimalSides[1];
		}
		
		if (decimalSides.count == 1) {
			decimalSide = decimalSides[0];
		}
		
		// Thousand separators
		if (withThousandSeparators) {
			let count = integerSide.count;
			var i = 3;
			var j = 0;
			
			while (i < count) {
				let index = (i + j) * -1;
				integerSide.insert(",", at: integerSide.index(integerSide.endIndex, offsetBy: index));
				
				i = i + 3;
				j = j + 1;
			}
		}
		
		// Final output
		stringNumber = "\((shouldGetCurrencySymbol && currency.hasSymbol) ? currency.symbol : "")\(integerSide)";
		stringNumber = (decimalSide == "0") ? "\(stringNumber)\(factorSymbol)" : "\(stringNumber).\(decimalSide)\(factorSymbol)";
		stringNumber = (!shouldGetCurrencySymbol || !currency.hasSymbol) ? "\(stringNumber) \(currency.rawValue)" : stringNumber;
		
		return stringNumber;
	}
	
	static func getCurrency(fromCurrencyCode currencyCode: String) -> Currency? {
		let allCurrencyCases = Currency.allCases;
		return allCurrencyCases.first(where: { $0.rawValue == currencyCode });
	}

}

enum NumberFactor {
	case auto
	case none
	case thousand
	case million
	case billion
	case trillion
	
	var factorValue: Int {
		switch self {
			case .thousand:
				return 1000;
			
			case .million:
				return 1000000;
			
			case .billion:
				return 1000000000;
			
			case .trillion:
				return 1000000000000;
			
			default:
				return 1;
		}
	}

	var symbol: String {
		switch self {
			case .thousand:
				return "K";
			
			case .million:
				return "M";
			
			case .billion:
				return "B";
			
			case .trillion:
				return "T";
			
			default:
				return "";
		}
	}
	
	var minDigitCount: Int {
		switch self {
			case .thousand:
				return 4;
			
			case .million:
				return 7;
			
			case .billion:
				return 10;
			
			case .trillion:
				return 13;
			
			default:
				return 1;
		}
	}

	func getRawNumber(number: Double, originalNumberFactor: NumberFactor) -> Double {
		return number * Double(originalNumberFactor.factorValue);
	}

	func getNumberFactor(rawNumber: Double) -> NumberFactor {
		let digitCount = String(Int(rawNumber)).count;
		
		if (digitCount >= NumberFactor.trillion.minDigitCount)	{ return NumberFactor.trillion }
		else if (digitCount >= NumberFactor.billion.minDigitCount)	{ return NumberFactor.billion }
		else if (digitCount >= NumberFactor.million.minDigitCount)	{ return NumberFactor.million }
		else if (digitCount >= NumberFactor.thousand.minDigitCount)	{ return NumberFactor.thousand }
		else { return NumberFactor.none }
	}
	
	func getNumberFactorSymbol(rawNumber: Double) -> String {
		let digitCount = String(Int(rawNumber)).count;
		
		if (digitCount >= NumberFactor.trillion.minDigitCount)	{ return NumberFactor.trillion.symbol }
		else if (digitCount >= NumberFactor.billion.minDigitCount)	{ return NumberFactor.billion.symbol }
		else if (digitCount >= NumberFactor.million.minDigitCount)	{ return NumberFactor.million.symbol }
		else if (digitCount >= NumberFactor.thousand.minDigitCount)	{ return NumberFactor.thousand.symbol }
		else { return NumberFactor.none.symbol }
	}

	func getFactoredNumber(rawNumber: Double, originalNumberFactor: NumberFactor = .none) -> Double {
		switch self {
			case .auto:
				let factor = getNumberFactor(rawNumber: rawNumber);
				return rawNumber / Double(factor.factorValue);
			
			default:
				return rawNumber / Double(self.factorValue);
		}
	}
}

enum Currency: String, CaseIterable {
	case none = ""
	case usd = "USD"
	case egp = "EGP"

	var symbol: String {
		switch self {
			case .usd:	return "$";
			default: 	return rawValue;
		}
	}

	var hasSymbol: Bool {
		switch self {
			case .usd:	return true;
			default: 	return false;
		}
	}
}
