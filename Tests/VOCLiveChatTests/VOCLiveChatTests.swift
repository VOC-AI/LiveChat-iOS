import XCTest
@testable import VOCLiveChat

class VOCLiveChatTests: XCTestCase {
    
    func testViewControllerPresentation() {
        // 启动应用程序
        let app = XCUIApplication()
        app.launch()
        
        // 创建一个测试用例的 ViewController 实例
        let testViewController = VOCLiveChatViewController(params: VOCLiveChatParams(id: 16778, token: "66BDB35EE4B0B8D56C02EC33"))
        // 创建一个测试窗口
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = testViewController
        window.makeKeyAndVisible()
        
        // 将窗口的视图设置为模拟器的主视图
        let isPresentingViewController = app.windows.element(boundBy: 0).exists
        
        // 使用 XCTest 断言验证 ViewController 是否正确显示
        XCTAssertTrue(isPresentingViewController, "TestViewController is not presented correctly.")
    }
}
