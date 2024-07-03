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
        
        static let calendarCircleFill = UIImage(systemName: "calendar.circle.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors: [.white, Constant.Color.customRed]))
        
        static let trayCircleFill = UIImage(systemName: "tray.circle.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors: [.white, Constant.Color.gray]))
        
        static let leafCircleFill = UIImage(systemName: "leaf.circle.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors: [.white, Constant.Color.blue]))
        
        static let flagCircleFill = UIImage(systemName: "flag.circle.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors: [.white, Constant.Color.customYellow]))
        
        static let plusCircleFill = UIImage(systemName: "plus.circle.fill")
    }
    
    enum Color {
        static let customGreen = UIColor(red: 106/255, green: 166/255, blue: 132/255, alpha: 1)
        static let customSkyBlue = UIColor(red: 84/255, green: 113/255, blue: 158/255, alpha: 1)
        static let blue = UIColor.systemBlue
        static let gray = UIColor.systemGray
        static let darkGary = UIColor.darkGray
        static let grayForBackView = UIColor.quaternaryLabel
        static let customRed = UIColor(red: 255/255, green: 69/255, blue: 58/255, alpha: 1)
        static let customYellow = UIColor(red: 255/255, green: 159/255, blue: 11/255, alpha: 1)
    }
    
    
}

