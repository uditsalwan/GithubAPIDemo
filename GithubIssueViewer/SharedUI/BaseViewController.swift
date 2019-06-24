//
//  BaseViewController.swift
//  GithubIssueViewer
//
//  Created by Udit on 24/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var loader: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     Show an Alert
     - Parameter title: Alert's title
     - Parameter message: Message to display in alert
     - Parameter okAction: Closure to perform on OK click
     - Parameter cancelAction: Closure to perform on Cancel click
     */
    func showAlert(title: String?, message: String?, okAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            okAction?()
        }))
        
        if let cancelAction = cancelAction {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                cancelAction()
            }))
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    /**
     Show an Alert with error
     - Parameter message: Message to display in alert
     - Parameter okAction: Closure to perform on OK click
     - Parameter cancelAction: Closure to perform on Cancel click
     */
    func handleError(message: String?, okAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        let title = "Error"
        showAlert(title: title, message: message, okAction: okAction, cancelAction: cancelAction)
    }
    
    /// Show / Hide loader on screen
    func showLoader(_ shouldShow: Bool) {
        DispatchQueue.main.async {
            if shouldShow, self.loader == nil {
                let loaderView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
                loaderView.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(loaderView)
                loaderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                loaderView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                loaderView.startAnimating()
                self.loader = loaderView
            } else if !shouldShow, self.loader != nil {
                self.loader?.stopAnimating()
                self.loader?.removeFromSuperview()
                self.loader = nil
            }
        }
    }
}
