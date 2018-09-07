//
//  GrantAccesViewController.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 30/08/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit
import WebKit
import Core
import Alamofire
import NVActivityIndicatorView


///  cambiar po SFAuthenticationSession
class GrantAccesViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    enum ResonseType: String {
        case code
        case token
    }
    
    public var onComplete: ((GrantAccesViewController) -> Void)!
    
    public var type: ResonseType = .code
    
    public var activityIndicator: NVActivityIndicatorView!
    
    public var usr: URL = URL(string: "https://bitbucket.org/site/oauth2/authorize?client_id=\(Http.client.key)&response_type=code")!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    


    
    convenience init(_ onComplete: @escaping (GrantAccesViewController) -> Void) {
        self.init()
        self.onComplete = onComplete
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bouds = UIScreen.main.bounds
        let frame = CGRect(origin: CGPoint(x: bouds.midX - 30, y:  bouds.midY - 60) , size: CGSize(width: 60, height: 60))
      
        
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballScale, color: Colors.primary, padding: 0)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        


        let close = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(closeAction))
        navigationItem.setLeftBarButton(close, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    
        let myRequest = URLRequest(url: self.usr)
        self.webView.load(myRequest)
    }

    @objc func closeAction() {
        webView.stopLoading()
        dismiss(animated: true) {

        }
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print("Closee")
        
    }

}


extension GrantAccesViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print(" didFinish \(webView.url?.scheme)")
        activityIndicator.stopAnimating()
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation \(webView.url!.scheme)")
        activityIndicator.startAnimating()
        if "file" != webView.url?.scheme {
//            showLoadingIndicator()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
            activityIndicator.stopAnimating()
           decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
          print("navigationAction")
        guard let URL =  navigationAction.request.url, "issueviewer" == URL.scheme,  let components = URLComponents(string:  URL.absoluteString.replacingOccurrences(of: "issueviewer:bit%23", with: "http://mysite3994.com?"))?.queryItems?.groupBy({ $0.name }) else {
              decisionHandler(WKNavigationActionPolicy.allow)
            return
        }
            
        switch type {
        case .token:
            
            if let token = components["access_token"]?.first?.value, let type =  components["token_type"]?.first?.value {
                Http.updateAut(token: token, tokenType: type, refresh: "nil")
                decisionHandler(WKNavigationActionPolicy.cancel)
                self.webView.stopLoading()
                self.dismiss(animated: true) {
                    self.onComplete(self)
                }
            } else {
                decisionHandler(WKNavigationActionPolicy.allow)
            }
            
        case .code:
            
            if let components = URLComponents(string:  URL.absoluteString.replacingOccurrences(of: "issueviewer:bit%23", with: "http://mysite3994.com?"))?.queryItems?.groupBy({ $0.name }),
            let code = components["code"]?.first?.value {
                Alamofire.request("https://\(Http.client.key):\(Http.client.secret)@bitbucket.org/site/oauth2/access_token", method: .post,
                                  parameters:[
                    "client_id"     : Http.client.key,
                    "client_secret" : Http.client.secret,
                    "grant_type"    : "authorization_code",
                    "code":code
                    ])
                    .responseJSON { (response) in
                    
                        if response.result.isFailure {
                            print("❌ Error I consultando ")
                            return
                        }
                        
                        guard let json = response.result.value as? [String: Any],
                            let access_token = json["access_token"] as? String,
                            let refresh_token = json["refresh_token"] as? String,
                            let token_type = json["token_type"] as? String else {
                            print("❌ Error II consultando url de servicos ")
                                return
                        }
                        
                        print("♻️ Resultado consultando url de servicos json=\(json)\n Actualizando Http ")
                        
                        Http.updateAut(token: access_token, tokenType: token_type, refresh: refresh_token)
                        self.webView.stopLoading()
                        self.dismiss(animated: true) {
                            self.onComplete(self)
                        }
                        
  
                        
                }
                  decisionHandler(WKNavigationActionPolicy.cancel)
            } else {
                decisionHandler(WKNavigationActionPolicy.allow)
            }
        }
        
    
    }
    
    
}
