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


///  cambiar po SFAuthenticationSession
class GrantAccesViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    public var onComplete: ((GrantAccesViewController) -> Void)!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    let html: String =  """
    <!DOCTYPE html>
    <html>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <head>
            <meta charset="UTF-8">
            <title>Title of the document</title>
        </head>

        <body>
            <div style="
                position: absolute;
                top: 50%;
                text-align: center;
                width: 100%;
                font-family: sans-serif;
                color: #205081;
                "> Loading...</div>
        </body>

    </html>
    """

    
    convenience init(_ onComplete: @escaping (GrantAccesViewController) -> Void) {
        self.init()
        self.onComplete = onComplete
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        //webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL);
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let clientId = Http.client.key
            let url = URL(string: "https://bitbucket.org/site/oauth2/authorize?client_id=\(clientId)&response_type=token")!
            let myRequest = URLRequest(url: url)
            self.webView.load(myRequest)
//        }

        let close = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(closeAction))
        navigationItem.setLeftBarButton(close, animated: false)
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        
        if let URL =  navigationAction.request.url,
            "issueviewer" == URL.scheme,
 
            let components = URLComponents(string:  URL.absoluteString.replacingOccurrences(of: "issueviewer:bit%23", with: "http://mysite3994.com?"))?.queryItems?.groupBy({ $0.name }),
                let token = components["access_token"]?.first?.value, let type =  components["token_type"]?.first?.value {
                Http.updateAut(token: token, tokenType: type)
                decisionHandler(WKNavigationActionPolicy.cancel)
                self.closeAction()
                self.onComplete(self)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
        
       
    }
    
    
}
