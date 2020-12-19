//
//  ErrorAlertView.swift
//  blockchain-member-app
//
//  Created by YORK CHAN on 29/10/2019.
//  Copyright © 2019 accenture. All rights reserved.
//

import Foundation
import UIKit

class AlertView {
    
    class func showErrorAlert(error: Error, target: UIViewController?) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        target?.present(alert, animated: true)
    }
    
    class func showAlert(title: String, message: String, target: UIViewController?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        target?.present(alert, animated: true)
    }
}
