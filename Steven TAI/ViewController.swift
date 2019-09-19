//
//  ViewController.swift
//  Steven TAI
//
//  Created by Kaleb Wijaya on 17/09/19.
//  Copyright © 2019 Kaleb Wijaya. All rights reserved.
//

import UIKit
import LocalAuthentication

enum AuthenticationState {
    case loggedin, loggedout
}

class ViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var label: UILabel!
    var context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        
        state = .loggedout
    }
    
    var state = AuthenticationState.loggedout {
        didSet {
            btnLogin.isHighlighted = state == .loggedin
            self.view.backgroundColor = state == .loggedin ? .green : .red
            label.isHidden = (state == .loggedin) || (context.biometryType != .faceID)
        }
    }
    
    @IBAction func btnTap(_ sender: Any) {
        if state == .loggedin {
            state = .loggedout
        } else {
            context = LAContext()
            context.localizedCancelTitle = "Enter Username/Password"
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    if success {
                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                            }
                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        }
                    }
            }
        }

    }
    


}

