//
// Copyright (c) 2019, Salesforce.com, inc.
// All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
//

import Nimbus
import UIKit
import WebKit

class TestBridge {
    init(host: UIViewController, webView: WKWebView) {
        self.host = host
        self.webView = webView
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .default,
                                      handler: nil))
        host?.present(alert, animated: true, completion: nil)
    }

    func currentTime() -> String {
        // Format the string so that javascript can instantiate a Date object with it.
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZZZZ"
        formatter.timeZone = TimeZone(abbreviation: "PST")
        var formattedDate = formatter.string(from: date)
        // Javascript doesn't like to have timezone in the formatted string
        formattedDate = formattedDate.replacingOccurrences(of: "GMT", with: "")
        return formattedDate
    }

    func withCallback(callback: (String) -> Void) {
        callback("hello from swift")
    }

    func initiateNativeCallingJs() {
        let boolParam = true
        let intParam = 999
        let optionalIntParam: Int? = nil
        let stringParam = "hello swift"
        let userDefinedTypeParam = UserDefinedType()
        let args = [boolParam, intParam, optionalIntParam, stringParam, userDefinedTypeParam] as [Encodable]
        webView?.callJavascript(name: "demoMethodForNativeToJs", args: args) { (result, _) -> Void in
            print(result!)
        }
    }

    func initiateNativeBroadcastMessage() {
        webView?.broadcastMessage(name: "systemAlert", arg: "red")
    }

    weak var host: UIViewController?
    weak var webView: WKWebView?
}

/**
 Test class used to pass from native to Javascript.
 */
class UserDefinedType: Encodable {
    var intParam = 5
    var stringParam = "hello user defined type"
}
