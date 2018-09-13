//
//  HPTabBarController.swift
//  HPTabBarController
//
//  Created by PangJunJie on 2018/9/13.
//

import UIKit

/// 只在DEBUG模式下打印
///
/// - Parameters:
///   - items: 打印内容s
///   - file: 打印文件
///   - line: 打印行号
///   - method: 打印方法
func dPrint(_ items: Any..., file: String = #file, line: Int = #line, method: String = #function) {
    #if DEBUG
    var log = "\((file as NSString).lastPathComponent)[第\(line)行]：\n"
    items.forEach { print($0, separator: "", terminator: " ", to: &log) }
    print(log)
    #endif
}

/// 是否需要自定义点击事件回调类型
public typealias HPTabBarControllerShouldHijackHandler = ((_ tabBarController: UITabBarController, _ viewController: UIViewController, _ index: Int) -> (Bool))
/// 自定义点击事件回调类型
public typealias HPTabBarControllerDidHijackHandler = ((_ tabBarController: UITabBarController, _ viewController: UIViewController, _ index: Int) -> (Void))

open class HPTabBarController: UITabBarController, HPTabBarDelegate {
    /// 当前tabBarController是否存在"More"tab
    open static func isShowingMore(_ tabBarController: UITabBarController?) -> Bool {
        return tabBarController?.moreNavigationController.parent != nil
    }
    
    /// Ignore next selection or not.
    fileprivate var ignoreNextSelection = false
    
    /// Should hijack select action or not.
    open var shouldHijackHandler: HPTabBarControllerShouldHijackHandler?
    /// Hijack select action.
    open var didHijackHandler: HPTabBarControllerDidHijackHandler?
    
    /// Observer tabBarController's selectedViewController. change its selection when it will-set.
    open override var selectedViewController: UIViewController? {
        willSet {
            guard let newValue = newValue else {
                // if newValue == nil ...
                return
            }
            
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            
            guard let tabBar = self.tabBar as? HPTabBar, let items = tabBar.items, let index = viewControllers?.index(of: newValue) else {
                return
            }
            
            let value = (HPTabBarController.isShowingMore(self) && index > items.count - 1) ? items.count - 1 : index
            tabBar.select(itemAtIndex: value, animated: false)
        }
    }
    
    /// Observer tabBarController's selectedIndex. change its selection when it will-set.
    open override var selectedIndex: Int {
        willSet {
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? HPTabBar, let items = tabBar.items else {
                return
            }
            let value = (HPTabBarController.isShowingMore(self) && newValue > items.count - 1) ? items.count - 1 : newValue
            tabBar.select(itemAtIndex: value, animated: false)
        }
    }
    
    /// Customize set tabBar use KVC.
    open override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = { () -> HPTabBar in
            let tabBar = HPTabBar()
            
            tabBar.delegate = self
            tabBar.customDelegate = self
            tabBar.tabBarController = self
            
            return tabBar
        }()
        self.setValue(tabBar, forKey: "tabBar")
    }
    
    // MARK: - UITabBar delegate
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.index(of: item) else {
            return;
        }
        if idx == tabBar.items!.count - 1, HPTabBarController.isShowingMore(self) {
            ignoreNextSelection = true
            selectedViewController = moreNavigationController
            return;
        }
        if let vc = viewControllers?[idx] {
            ignoreNextSelection = true
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: vc)
        }
    }
    
    open override func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
        if let tabBar = tabBar as? HPTabBar {
            tabBar.updateLayout()
        }
    }
    
    open override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        if let tabBar = tabBar as? HPTabBar {
            tabBar.updateLayout()
        }
    }
    
    // MARK: - ESTabBar delegate
    internal func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.index(of: item), let vc = viewControllers?[idx] {
            return delegate?.tabBarController?(self, shouldSelect: vc) ?? true
        }
        return true
    }
    
    internal func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.index(of: item), let vc = viewControllers?[idx] {
            return shouldHijackHandler?(self, vc, idx) ?? false
        }
        return false
    }
    
    internal func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem) {
        if let idx = tabBar.items?.index(of: item), let vc = viewControllers?[idx] {
            didHijackHandler?(self, vc, idx)
        }
    }
    
}
