//
//  WebViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: UXViewController, WebUIDelegate, WebPolicyDelegate, WebFrameLoadDelegate {

	let webView = WebView()
	let loadingIndicatorView = CHRLoadingIndicatorView()

	var initialRequest: NSURLRequest?

	func viewControllerClass(for url: URL) -> Class {
		// TODO: implement
		HBLogInfo("url: %@", url)
		return CHRWebViewController.dynamicType
	}

	init(request: NSURLRequest) {
		initialRequest = request
	}

	// MARK: - View

	func loadView() {
		super.loadView()

		title = NSLocalizedString("UNTITLED", "Title of a page that has no defined title.")

		webView = WebView(frame: view.bounds)
		webView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
		webView.UIDelegate = self;
		webView.policyDelegate = self;
		webView.frameLoadDelegate = self;
		view.addSubview(webView)

		self.navigationItem.leftBarButtonItem = UXBarButtonItem(customView: loadingIndicatorView)

		if initialRequest != nil {
			webView.mainFrame.loadRequest(initialRequest!)
			initialRequest = nil
		}
	}

	// MARK: - WebKit

	func webView(_ webView: WebView!, decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!, request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
		// based on the url being loaded, determine whether we should do some sort
		// of native thing here
		if request.URL.scheme == "mailto" {
			// cancel request
			listener.ignore()

			// hand over to our email sending controller
			let emailSendingController = CHREmailSendingController()
			emailSendingController.handleEmailWithURL(request.URL, window: view.window)
		} else {
			// tell it to go ahead
			listener.use()
		}
	}

	func webView(_ sender: WebView!, createWebViewWith request: URLRequest!) -> WebView! {
		// the page wants to open a new window. determine the web view controller
		// subclass to use
		let newClass = WebViewController.viewControllerClass(for: request.URL)

		// instantiate it with the request, and push it
		let viewController = newClass(request: request)
		navigationController.pushViewController(viewController, animated: true)
	}

	func webView(_ webView: WebView!, didClearWindowObject windowObject: WebScriptObject!, for frame: WebFrame!) {
		// the javascript `window` object has been reset. use this opportunity to
		// inject our web script objects

		// if the url matches one that should be allowed to use the script object
		if url.scheme == "https" && url.host == NSURL(kCHRWebUIRootURL).host {
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

	func handleFailedLoad(error: NSError, for frame: WebFrame) {
		// display error alert
		let alert = NSAlert(error: error)
		alert.beginSheetModal(for: view.window)

		// if this is the main frame
		if frame == webView.mainFrame {
			// assume the load has finished and hide the indicator
			loadingIndicatorView.stopAnimation(nil)
		}
	}

	func webView(_ sender: WebView!, didFailProvisionalLoadWithError error: NSError!, for frame: WebFrame!) {
		handleFailedLoad(error, frame: frame)
	}

	func webView(_ sender: WebView!, didFailLoadWithError error: NSError!, for frame: WebFrame!) {
		handleFailedLoad(error, frame: frame)
	}

}
