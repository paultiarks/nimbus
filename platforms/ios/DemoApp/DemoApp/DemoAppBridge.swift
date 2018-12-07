//
//  Copyright © 2018 Salesforce.com, inc. All rights reserved.
//

import UIKit

class DemoAppBridge {

    init(host: UIViewController) {
        self.host = host
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
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

    func withCallback(callback: (String) -> ()) {
        callback("hello from swift")
    }

    weak var host: UIViewController?
}
