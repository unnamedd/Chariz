//
//  WebViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa
import WebKit

@objc class WebViewController: UXViewController, WebUIDelegate, WebPolicyDelegate, WebFrameLoadDelegate {

	let webView = WebView()
	let loadingIndicatorView = LoadingIndicatorView()

	var initialRequest: URLRequest?
	private var deferredAlert: NSAlert?

	class func viewControllerClass(for url: URL?) -> WebViewController.Type {
		// TODO: implement
		log(.debug, "url: \(String(describing: url))")
		return WebViewController.self
	}
	
	required init() {
		super.init(nibName: nil, bundle: nil)
		title = NSLocalizedString("UNTITLED", comment: "Title of a page that has no defined title.")
	}

	convenience init(request: URLRequest) {
		self.init()
		initialRequest = request
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View

	override func loadView() {
		super.loadView()

		webView.frame = view.bounds
		webView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
		webView.uiDelegate = self
		webView.policyDelegate = self
		webView.frameLoadDelegate = self
		view.addSubview(webView)

		self.navigationItem.leftBarButtonItem = UXBarButtonItem(customView: loadingIndicatorView)
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()

		if initialRequest != nil {
			webView.mainFrame.load(initialRequest!)
			initialRequest = nil
		}
		
		if deferredAlert != nil {
			deferredAlert!.beginSheetModal(for: view.window!)
			deferredAlert = nil
		}
	}

	// MARK: - WebKit
	
	func webView(_ webView: WebView!, decidePolicyForNavigationAction actionInformation: [AnyHashable : Any]!, request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
		// based on the url being loaded, determine whether we should do some sort of native thing here
		if request.url?.scheme == "mailto" {
			// cancel request
			listener.ignore()

			// hand over to our email sending controller
			let emailSendingController = EmailSendingController()
			emailSendingController.handleEmail(with: request.url, window: view.window)
		} else {
			// tell it to go ahead
			listener.use()
		}
	}

	func webView(_ sender: WebView!, createWebViewWith request: URLRequest!) -> WebView! {
		// the page wants to open a new window. determine the web view controller subclass to use
		let newClass = WebViewController.viewControllerClass(for: request.url)

		// instantiate it with the request, and push it
		let viewController = newClass.init()
		viewController.initialRequest = request
		navigationController.pushViewController(viewController, animated: true)
		
		// WebView needs to know the new WebView so the two windows can communicate if necessary
		return viewController.webView
	}

	func webView(_ webView: WebView!, didClearWindowObject windowObject: WebScriptObject!, for frame: WebFrame!) {
		// the javascript `window` object has been reset, probably because a new page is being loaded.
		// use this opportunity to inject our web script objects
		let url = frame.dataSource!.request!.url!

		// if the url matches one that should be allowed to use the script object
		if url.scheme == "https" && url.host == charizWebUIURL.host {
			// set the web script objects
			let webScriptObject = CharizWebScriptObject()
			windowObject.setValue(webScriptObject, forKey: "chariz")
			windowObject.setValue(webScriptObject, forKey: "cydia")
		}
	}

	// MARK: - Loading

	func webView(_ sender: WebView!, didStartProvisionalLoadFor frame: WebFrame!) {
		// display loading indicator
		loadingIndicatorView.startAnimation(nil)
	}

	func webView(_ sender: WebView!, didCommitLoadFor frame: WebFrame!) {
		// hide loading indicator
		loadingIndicatorView.stopAnimation(nil)
	}

	func handleFailedLoad(error: Error, for frame: WebFrame) {
		// display error alert
		let alert = NSAlert(error: error as NSError)
		
		if view.window == nil {
			deferredAlert = alert
		} else {
			alert.beginSheetModal(for: view.window!)
		}

		// if this is the main frame
		if frame == webView.mainFrame {
			// assume the load has finished and hide the indicator
			loadingIndicatorView.stopAnimation(nil)
		}
	}

	func webView(_ sender: WebView!, didFailProvisionalLoadWithError error: Error!, for frame: WebFrame!) {
		handleFailedLoad(error: error, for: frame)
	}

	func webView(_ sender: WebView!, didFailLoadWithError error: Error!, for frame: WebFrame!) {
		handleFailedLoad(error: error, for: frame)
	}

}
