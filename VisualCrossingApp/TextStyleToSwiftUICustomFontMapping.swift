//
//  TextStyleToSwiftUICustomFontMapping.swift
//  Mavs
//
//  Created by Saad Umar on 9/19/22.
//  Copyright © 2022 Tixsee LLC. All rights reserved.
//

import Foundation
import UIKit

struct TextStyleToSwiftUICustomFontMapping {
    private var customFont = SwiftUIFontModel()
    
    init(textStyle:TextStyle) {
        let attributes = textStyle.attributes
        let font = attributes[.font] as? UIFont ?? UIFont()
        self.customFont.fontName = font.fontName
        self.customFont.fontSize = font.pointSize
        self.customFont.fontColor = attributes[.foregroundColor] as? UIColor ?? UIColor.clear
    }
    
    func toUIFont() -> UIFont {
        return UIFont(name: customFont.fontName, size: customFont.fontSize) ?? UIFont()
    }
    
    func fontColor() -> UIColor {
        return customFont.fontColor
    }
}

