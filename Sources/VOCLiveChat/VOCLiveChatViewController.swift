import UIKit
import WebKit
import Foundation

func encodeURIComponent(_ string: String) -> String? {
    // 定义允许在 URL 中出现的字符集
    let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
    // 使用 `addingPercentEncoding` 方法进行编码
    return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
}

public class VOCLiveChatViewController: UIViewController, WKUIDelegate {
    public var uiDelegate: VOCLiveChatDelegate?
    var vocWebview: VOCWebView!
    var params: VOCLiveChatParams?
    
    public func webview() -> WKWebView {
        return self.vocWebview
    }
    
    // 声明一个 title 属性
    public var pageTitle: String? {
        didSet {
            // 在 title 更新时设置导航栏标题
            self.navigationItem.title = pageTitle
        }
    }
    
    // 初始化方法
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
    
    // 从 xib 或 storyboard 创建时调用的初始化方法
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func buildURL(withBase baseURL: String, params: VOCLiveChatParams) -> URL? {
        // 创建 URLComponents 实例
        var urlComponents = URLComponents(string: baseURL)
        
        // 构建查询项数组
        let queryParams: [String: String?] = [
            "id": "\(params.id)",
            "token": params.token,
            "brand": params.brand,
            "country": params.country,
            "email":params.email,
            "language": params.language,
            "lang": (params.lang != nil) ? "\(params.lang?.rawValue ?? "")" : nil,
            "encrypt": "\(params.encrypt ?? false ? "true" : "")",
        ]
        //        if let email = params.email {
        //            queryParams["email"] = encodeURIComponent(email)
        //        }
        let queryItems = queryParams.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        // 将查询项数组赋值给 URLComponents
        urlComponents?.queryItems = queryItems
        
        // 返回构建的 URL
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
    
    // 视图加载完成后调用
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 配置 WKWebView 并将其添加到视图中
        configureWebView()
    }
    
    // 配置 WKWebView
    private func configureWebView() {
        vocWebview = VOCWebView(frame: self.view.bounds)
        vocWebview.uiDelegate = self
        vocWebview.scrollView.bounces = false
        vocWebview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(vocWebview)
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
