//
//  VOCLiveChatViewControllerDelegate.swift
//  testVOCLiveChat
//
//  Created by Boyuan Gao on 2024/8/15.
//

import Foundation

/**
 Delegate of VOCLiveChatViewController
 */
public protocol VOCLiveChatDelegate {
    
    /**
     To determin whether to open the link, return true to keep opening
     */
    func VOCLiveChatBeforeOpenLink(link: URL) -> Bool
    
    /**
     How to open the link, return false to use default openLink behavior
     */
    func VOCLiveChatOpenLink(link: URL) -> Bool
    
    /**
     After open link
     */
    func VOCLiveChatAfterOpenLink(link: URL) -> Void
}
