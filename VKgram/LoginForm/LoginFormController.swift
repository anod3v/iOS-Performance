//
//  LoginFormController.swift
//  LoginForm
//
//  Created by Andrey on 30/07/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit
import WebKit
//import FirebaseAuth

class LoginFormViewController: UIViewController {
    
    var webView: WKWebView = {
        let view = WKWebView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    
    var networkService = NetworkService()
    
//    let firebaseService = FirebaseService() // TODO: to integrate firebase
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(webView)
        webView.pin(to: self.view)
        webView.navigationDelegate = self
        
        let credentialsRequest = networkService.getLoginForm()
        webView.load(credentialsRequest)
        
    }
    
}

extension LoginFormViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
//        debugPrint("url:", url)
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = params["access_token"]
        
        let userId = params["user_id"]
        
        Session.shared.token = token
        
        Session.shared.userId = Int(userId!)
        
//        func singInAnonymouslyToFirebase(success: @escaping () -> Void) {
//            Auth.auth().signInAnonymously { (result, error) in
//                switch error {
//                case let .some(error):
//                    debugPrint(error.localizedDescription)
//                default:
//                    success()
//                }
//            }
//        }
        
        
        
//        try? Auth.auth().signOut()
        
//        singInAnonymouslyToFirebase() { [unowned self] in
//
//            self.firebaseService.saveUser(userID: Session.shared.userId!)
        
            let tabBarController = MainTabBarViewController()
        
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
//        }
        
        decisionHandler(.cancel)
    }
}
