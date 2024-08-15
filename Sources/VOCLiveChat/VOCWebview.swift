import UIKit
import WebKit

/**
 * 创建一个封装 WKWebView 的自定义视图控制器
 */
class VOCWebView: WKWebView {

    // 加载指定的 URL
    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        self.load(request)
    }
}
