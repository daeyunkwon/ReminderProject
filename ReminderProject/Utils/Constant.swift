//
//  Constant.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit

enum Constant {
    
    enum SymbolImage {
        static let plusCircle = UIImage(systemName: "plus.circle")
        
        static let ellipsisCircle = UIImage(systemName: "ellipsis.circle")
        
        static let checkmarkCircleFill = UIImage(systemName: "checkmark.circle.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors: [.white, Constant.Color.customGreen]))
        
        static let circle = UIImage(systemName: "circle")
        
        static let chevronRight = UIImage(systemName: "chevron.right")
    }
    
    enum Color {
        static let customGreen = UIColor(red: 106/255, green: 166/255, blue: 132/255, alpha: 1)
        static let customSkyBlue = UIColor(red: 84/255, green: 113/255, blue: 158/255, alpha: 1)
        static let blue = UIColor.systemBlue
        static let gray = UIColor.systemGray
        static let darkGary = UIColor.darkGray
        static let quaternaryLabel = UIColor.quaternaryLabel
    }
    
    
}

