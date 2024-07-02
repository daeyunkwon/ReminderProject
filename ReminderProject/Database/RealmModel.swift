//
//  RealmModel.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/3/24.
//

import Foundation

import RealmSwift

enum ReminderRealmError: Error {
    case noRealm
    case failedToAdd
    
    var errorDescription: String {
        switch self {
        case .noRealm:
            return "Error: default.realm 파일을 찾는데 실패했습니다."
        case .failedToAdd:
            return "Error: realm에 데이터 쓰기가 실패했습니다."
        }
    }
}

class Reminder: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var todoTitle: String
    @Persisted var todoContent: String?
    @Persisted var deadline: String?
    
    convenience init(todoTitle: String, todoContent: String? = nil, deadline: String? = nil) {
        self.init()
        self.todoTitle = todoTitle
        self.todoContent = todoContent
        self.deadline = deadline
    }
    
    enum Key: String {
        case todoTitle
        case todoContent
        case deadline
    }
}
