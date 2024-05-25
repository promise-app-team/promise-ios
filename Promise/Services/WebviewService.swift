//
//  WebviewService.swift
//  Promise
//
//  Created by kwh on 5/3/24.
//

import UIKit
import WebKit


class WebViewService {
    static let shared = WebViewService()
    private init() {}  // Private initializer to ensure singleton usage

    func presentWebView(urlString: String, from viewController: UIViewController) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let webViewController = WebViewController(url: url)
        viewController.present(webViewController, animated: true, completion: nil)
    }
}

class WebViewController: UIViewController {
    var webView: WKWebView!
    let url: URL

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
