import UIKit
import WebKit
import Foundation

/**
 Encode URI Component as javascript
 */
func encodeURIComponent(_ string: String) -> String? {
    let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
    return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
}


public class VOCLiveChatViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    /**
     Set delegate
     */
    public var uiDelegate: VOCLiveChatDelegate?
    var vocWebview: VOCWebView!
    var params: VOCLiveChatParams?
    
    
    public func webview() -> WKWebView {
        return self.vocWebview
    }
    
    // to set title for navigationItem
    public var pageTitle: String? {
        didSet {
            // 在 title 更新时设置导航栏标题
            self.navigationItem.title = pageTitle
        }
    }
    
    // init
    public init(params: VOCLiveChatParams) {
        super.init(nibName: nil, bundle: nil)
        self.params = params
        self.configureWebView()
        if let url = self.generateURI(params: params) {
            self.vocWebview.loadURL(url)
        } else {
            print("Error: VOC WebView URL Error.")
        }
    }
    
    // init
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func buildURL(withBase baseURL: String, params: VOCLiveChatParams) -> URL? {
        // start to build url
        var urlComponents = URLComponents(string: baseURL)
        
        // consturct queries
        var queryParams: [String: String?] = [
            "id": "\(params.id)",
            "token": params.token,
            "brand": params.brand,
            "country": params.country,
            "email":params.email,
            "language": params.language,
            "lang": (params.lang != nil) ? "\(params.lang?.rawValue ?? "")" : nil,
            "encrypt": "\(params.encrypt ?? false ? "true" : "")",
            "noHeader": "\(params.noHeader ?? false ? "true" : "")",
            "noBrand": "\(params.noBrand ?? false ? "true" : "")",
            "channelid": params.channelid,
            "skill_id": params.skill_id,
        ]
        
        if let otherParams = params.otherParams {
            queryParams.merge(otherParams) { (_, new) in new }
        }
        
        //        if let email = params.email {
        //            queryParams["email"] = encodeURIComponent(email)
        //        }
        let queryItems = queryParams.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        urlComponents?.queryItems = queryItems
        
        // return built url
        return urlComponents?.url
    }
    
    private func generateURI(params: VOCLiveChatParams) -> URL? {
        let host = params.isTest ?? false ? "https://apps-staging.voc.ai" : "https://apps.voc.ai"
        let baseUrl = "\(host)/live-chat"
        if let url = self.buildURL(withBase: baseUrl, params: params) {
            print(url)
            return url
        }
        
        return nil
    }
    
    // config webview
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        configureWebView()
    }
    
    // config webview
    private func configureWebView() {
        vocWebview = VOCWebView(frame: self.view.bounds)
        vocWebview.navigationDelegate = self
        vocWebview.uiDelegate = self
        vocWebview.scrollView.bounces = false
        vocWebview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(vocWebview)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.adjustWebViewLayout()
    }
    
    private func adjustWebViewLayout() {
        let origin = CGPoint(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top)
        let width = self.view.bounds.size.width - view.safeAreaInsets.left - view.safeAreaInsets.right
        var height = self.view.bounds.size.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
        let size = CGSize(width: width, height: height)
        
        var navigationBarHeight = 44.0
        if let navigationController = self.navigationController {
            let navBarFrame = navigationController.navigationBar.frame
            navigationBarHeight = navBarFrame.height
            height = height - navigationBarHeight
        }
        
        self.vocWebview?.frame = CGRect(origin: origin, size: size)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vocWebview.frame = self.view.bounds
    }
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.navigationType == .linkActivated || navigationAction.navigationType == .other, let url = navigationAction.request.url {
            var opened = false
            if let uiDelegate = self.uiDelegate {
                let shouldOpen = uiDelegate.VOCLiveChatBeforeOpenLink(link: url)
                if shouldOpen {
                    let useDefaultOpen = !uiDelegate.VOCLiveChatOpenLink(link: url)
                    if (useDefaultOpen) {
                        self.defaultOpen(url: url)
                    }
                    opened = true
                }
                if opened {
                    uiDelegate.VOCLiveChatAfterOpenLink(link: url)
                }
            } else {
                self.defaultOpen(url: url)
            }
        }
        return nil
    }
    
    func pushWebViewController() {
        let webViewController = VOCLiveChatViewController(params: self.params!)
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    private func defaultOpen(url: URL) {
        let openLinkType = self.params?.openLinkType ?? VOCLiveChatLinkOpenType.openWithBrowser
        switch openLinkType {
        case VOCLiveChatLinkOpenType.openWithBrowser:
            UIApplication.shared.open(url)
            break
        }
    }
}
