import UIKit
import WebKit

/**
 * WebView with some method for furthure usage
 */
class VOCWebView: WKWebView {

    // load url
    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        self.load(request)
    }
}
