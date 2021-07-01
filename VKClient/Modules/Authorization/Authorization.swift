//
//  Authorization.swift
//  VKClient
//
//  Created by Olya Ganeva on 23.06.2021.
//

import UIKit
import WebKit

class Authorization: UIViewController {

    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        authorizeToVK()
    }

    private func setupWebView() {
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func authorizeToVK() {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7822904"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "1"),
            URLQueryItem(name: "v", value: "5.68")
        ]

        let request = URLRequest(url: urlComponents.url!)

        webView.load(request)
    }
}

extension Authorization: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }

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

        if let token = params["access_token"], let userId = params["user_id"] {
            print("TOKEN = ", token as Any)
            Session.shared.token = token
            Session.shared.userId = userId

            showMainTabBar()
        }

        decisionHandler(.cancel)
    }

    func showMainTabBar() {
        navigationController?.pushViewController(FriendsViewController(), animated: true)
    }
}
