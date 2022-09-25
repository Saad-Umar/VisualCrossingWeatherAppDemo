//
//  AppBaseWebService.swift
//
//  Created by Saad Umar on 9/23/22.
//

import Foundation
import UIKit

class AppBaseWebService {
    
    init() {
        AppWebService.configure(delegate: self)
    }
}

extension AppBaseWebService : AppWebServiceDelegate {
    var defaultHeaders: [String : String] {
        let userAgentString = "iOS;" + String(UIDevice.current.model) + ";" + String(UIDevice.current.systemVersion)
        
        var header = [
            "Content-Type": "application/json",
            "User-Agent": userAgentString
        ]
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            header["x-appversion"] = version
        }
        header["authorization"] = UserDefaults.standard.object(forKey: "APP_USER_JWT") as? String ?? ""

       return header
    }
}

