//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: StyleUIViewControllerBase, ShowingLoadingIndicator, HandlingKeyboard, Scrollable {
	
	// MARK: - VC Events
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// Dependencies
		alert = AppDelegate.di.container.resolve(PAlert.self)!;
		alert.setParentView(as: self);
		makeSpinner(indicatorColor: .white, backgroundColor: AppColor.indicatorBackgroundTransparent);

		// Keyboard handling
		setupTapGesture();
		setupKeyboardPositioning();
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated);
		
		unsubscribeFromAllNotifications();
	}

	// MARK: - Spinner/Indicator
	private var spinner: UIView!;
	
	internal func makeSpinner(indicatorColor: UIColor?, backgroundColor: UIColor?) {
		spinner = AppDelegate.di.makeSpinnerView(indicatorColor: indicatorColor, backgroundColor: backgroundColor);
	}
	
	internal func setIndicator(asShown: Bool) {
		if (asShown) {
			showIndicator();
		}
		else {
			hideIndicator();
		}
	}

	internal func showIndicator() {
		view.addSubview(spinner);
		
		// Constraints
		NSLayoutConstraint.activate([
			spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	internal func hideIndicator() {
		spinner.removeFromSuperview();
	}

	// MARK: - Alerts
	var alert: PAlert!;

	internal func showAlert(title: String? = nil, message: String, actionButtonText: String? = nil, action: VoidClosure? = nil) {
		if let actionButtonText = actionButtonText {
			alert.error(title: title, message: message, actionButtonText: actionButtonText) { (alertAction) in
				action?();
			}
		}
		else {
			alert.info(title: title, message: message) { (alertAction) in
				action?();
			}
		}
	}
	
	// MARK: - Connection Status
	private var noConnectionAction: VoidClosure?
	
	func configNoConnectionAction(withAction action: @escaping VoidClosure) {
		self.noConnectionAction = action;
	}
	
	func showNoConnectionMessage() {
		if let noConnectionAction = noConnectionAction {
			noConnectionAction();
			return;
		}

		alert.info(message: ErrorType.noConnection.localizedMessage);
	}
	
	// MARK: - Scrolling
	/*
	Refer to this link for details:
		https://www.notion.so/mstdev/Implement-Scrolling-Using-My-BaseViewController-Step-by-Step-a8937942fd7a46a699a9681875cbea86
	
	Brief steps:
	- Set top view's size to Freeform
	- Add a content view (ViewContent) with no siblings, use appropriate contraints for it
	- Follow the mentioned link about its size and position
	- Reference the ViewContent in your code
	- Call the setupScrollView method, and pass the ViewContent to it
	*/
	
	var scrollView: UIScrollView?
	var viewScrolledContent: UIView?

	// Call this method only if you have scrolling in your ViewConroller, take care of the Prerequisites above
	internal func setupScrollView(contentView: UIView) {
		// Init
		scrollView = UIScrollView();
		viewScrolledContent = UIView();
		guard let scrollView = scrollView, let viewScrolledContent = viewScrolledContent else { return }


		// Constrain content extension
		self.edgesForExtendedLayout = [.bottom];

		// Detach the content view from super view
		contentView.removeFromSuperview();
		
		/// Build control hierarchy for scrolling
		// ScrollView
		scrollView.translatesAutoresizingMaskIntoConstraints = false;
		view.addSubview(scrollView);
		scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
		scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
		scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
		
		// ViewScrolledContent
		viewScrolledContent.translatesAutoresizingMaskIntoConstraints = false;
		scrollView.addSubview(viewScrolledContent);
		viewScrolledContent.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true;
		viewScrolledContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true;
		viewScrolledContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true;
		viewScrolledContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true;
		viewScrolledContent.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true;
		
		// Content View
		contentView.translatesAutoresizingMaskIntoConstraints = false;
		viewScrolledContent.addSubview(contentView);
		contentView.topAnchor.constraint(equalTo: viewScrolledContent.topAnchor).isActive = true;
		contentView.bottomAnchor.constraint(equalTo: viewScrolledContent.bottomAnchor).isActive = true;
		contentView.leadingAnchor.constraint(equalTo: viewScrolledContent.leadingAnchor).isActive = true;
		contentView.trailingAnchor.constraint(equalTo: viewScrolledContent.trailingAnchor).isActive = true;
	}
	
	// MARK: - Keyboard Handling
	/// Setup keyboatd positioning over scoll view.
	internal func setupKeyboardPositioning() {
		// Subscribe to a Notification which will fire before the keyboard will show
		subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShow));
		
		// Subscribe to a Notification which will fire before the keyboard will hide
		subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillHide));
	}
	
	/// Setup global tap gesture.
	internal func setupTapGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapHandler(recognizer:)));
		tapGesture.cancelsTouchesInView = false;
		self.view.addGestureRecognizer(tapGesture);
	}
	
	/// Handle global tap gesture.
	@objc internal func viewTapHandler(recognizer: UISwipeGestureRecognizer) {
		self.dismissKeyboard();
	}
	
	/// Dismiss keyboard.
	internal func dismissKeyboard() {
		self.view.endEditing(true);
	}
	
	/// Handle keyboard when shown.
	@objc func keyboardWillShow(notification: NSNotification) {
		// Get required info out of the notification
		if let scrollView = scrollView,
			let userInfo = notification.userInfo,
			let keyboardFrameAtEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey],
			let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey],
			let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
			
			// Transform the keyboard's frame into our view's coordinate system
			let endRect = view.convert((keyboardFrameAtEnd as AnyObject).cgRectValue, from: view.window);
			
			// Find out how much the keyboard overlaps our scroll view
			let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y;
			
			// Set the scroll view's content inset & scroll indicator to avoid the keyboard
			scrollView.contentInset.bottom = keyboardOverlap;
			scrollView.scrollIndicatorInsets.bottom = keyboardOverlap;
			
			let duration = (durationValue as AnyObject).doubleValue;
			let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16));
			
			UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
				self.view.layoutIfNeeded()
			}, completion: nil);
		}
	}
	
	/// Handle keyboard when hidden.
	@objc func keyboardWillHide(notification: Notification) {
		scrollView?.contentInset = UIEdgeInsets.zero;
	}

	// MARK: - Functions
	func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
		NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil);
	}
	
	func unsubscribeFromAllNotifications() {
		NotificationCenter.default.removeObserver(self);
	}

}
