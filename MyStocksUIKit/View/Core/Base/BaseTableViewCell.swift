//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell, InjectableTableViewCell {
	weak var delegate: EmitErrorDelegate?;

	static var cellId: String {
		return "\(Self.self)";
	}
	
	static var bundle: Bundle {
		return Bundle(for: Self.self);
	}
	
	static var nib: UINib {
		return UINib(nibName: Self.cellId, bundle: Self.bundle);
	}
	
	static func register(with tableView: UITableView) {
		tableView.register(Self.nib, forCellReuseIdentifier: Self.cellId);
	}
	
	static func loadFromNib(owner: Any?) -> Self {
		return bundle.loadNibNamed(Self.cellId, owner: owner, options: nil)?.first as! Self;
	}
	
	static func dequeue(from tableView: UITableView, for indexPath: IndexPath) -> Self {
		let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellId, for: indexPath) as! Self;
		return cell;
	}
}
