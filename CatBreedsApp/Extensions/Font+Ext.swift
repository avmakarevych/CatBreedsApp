//
//  Font+Ext.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//

import SwiftUI

extension Font {
    
    enum NohemiFont {
        case bold
        case regular
        case medium
        case custom(String)
        
        var value: String {
            switch self {
            case .bold:
                return "Nohemi-Bold"
            case .regular:
                return "Nohemi-Regular"
            case .medium:
                return "Nohemi-Medium"
                
            case .custom(let name):
                return name
            }
        }
    }
    
    
    static func nohemi(_ type: NohemiFont, size: CGFloat = 26) -> Font {
        return .custom(type.value, size: size)
    }
    
}
