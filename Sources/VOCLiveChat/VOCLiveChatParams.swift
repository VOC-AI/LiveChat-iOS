//
//  VOCLiveChatParams.swift
//  
//  @brief Params to initiate a livechat viewcontroller
//  Created by Boyuan Gao on 2024/8/15.
//

public enum VOCLiveChatLinkOpenType: String {
    case openWithBrowser = "browser"
}

/**
 System UI display language
 */
public enum VOCLiveChatSystemLang: String {
    case English = "en-US"
    case Chinese = "zh-CN"
    case Japanese = "ja-JP"
    case French = "fr-FR"
    case German = "de-DE"
    case Spanish = "es-ES"
    case Portuguese = "pt-PT"
    case Arabic = "ar"
    case Philippines = "fl"
    case Indonesian = "in"
}

/**
 Params to initiate a livechat viewcontroller
 */
public struct VOCLiveChatParams {
    public init(id: Int, token: String) {
        self.id = id;
        self.token = token;
    }
    /**
     The id of livechat, aquire the id at the 'integration center' of voc.ai chatbot system
     */
    public var id: Int
    /**
     The token of livechat, aquire the token at the 'integration center' of voc.ai chatbot system
     */
    public var token: String
    /**
     Once determined the email of customer, this will no longer require the user input any email information
     */
    public var email: String?
    /**
     To indicate the brand of current livechat
     */
    public var brand: String?
    /**
     To indicate the country of customer
     */
    public var country: String?
    /**
     To indicate the language of customer inqueries
     */
    public var language: String?
    /**
     The language setting of user interface.
     */
    public var lang: VOCLiveChatSystemLang?
    /**
     If the passed email is encrypted
     */
    public  var encrypt: Bool?
    /**
     If it's test environment
     */
    public var isTest: Bool?
    
    /**
     Default behavior when open link from the livechat
     */
    public var openLinkType: VOCLiveChatLinkOpenType?
    
}
