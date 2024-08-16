# VOCLiveChat


Demo code.
```swift

import SwiftUI
import UIKit
import VOCLiveChat

final class Del: VOCLiveChatDelegate {
    
    func VOCLiveChatBeforeOpenLink(link: URL) -> Bool {
        return true
    }
    
    func VOCLiveChatOpenLink(link: URL) -> Bool {
        print("aaa", link)
        return false
    }
    
    func VOCLiveChatAfterOpenLink(link: URL) {
        
    }
}

struct OldContentView:  UIViewControllerRepresentable {
    let del = Del()
    
    func makeUIViewController(context: Context) -> VOCLiveChatViewController {
        var params = VOCLiveChatParams(id: 1, token: "66BDF3**********52B3")
        params.email = "testemail@abc.com"
        params.lang = VOCLiveChatSystemLang.Arabic
        let vc = VOCLiveChatViewController(params: params)
        vc.uiDelegate = self.del
        vc.pageTitle = "Haha"
        return vc
    }
    
    func updateUIViewController(_ uiViewController: VOCLiveChatViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = VOCLiveChatViewController
}


// SwiftUI 主视图
struct ContentView: View {
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    OldContentView()
                        .edgesIgnoringSafeArea(.all)
                }.padding(0)
                    .navigationTitle("Title")
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

```
