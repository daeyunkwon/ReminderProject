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
    case failedToWrite
    case failedToUpdate
    case failedToDelete
    
    var errorDescription: String {
        switch self {
        case .noRealm:
            return "Error: default.realm 파일을 찾는데 실패했습니다."
        case .failedToWrite:
            return "Error: realm에 데이터 쓰기가 실패했습니다."
        case .failedToDelete:
            return "Error: realm에 데이터 삭제가 실패했습니다."
        case .failedToUpdate:
            return "Error: realm에 데이터 없데이트가 실패했습니다."
        }
    }
}

class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var regDate: Date
    
    @Persisted var reminderList: List<Reminder>
    
    convenience init(name: String) {
        self.init()
        self.name = name
        self.regDate = Date()
    }
    
    enum Key: String {
        case name
        case regDate
        case reminderList
    }
}

class Reminder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var todoTitle: String
    @Persisted var todoContent: String?
    @Persisted var deadline: Date?
    @Persisted var tag: String?
    @Persisted var priority: Int //우선순위 기준 -> 1: 높음, 2: 보통, 3: 낮음
    @Persisted var isDone: Bool
    @Persisted var flag: Bool
    @Persisted var imageID: String?
    
    @Persisted(originProperty: Folder.Key.reminderList.rawValue) var main: LinkingObjects<Folder>
    
    convenience init(todoTitle: String, todoContent: String? = nil, deadline: Date? = nil, tag: String? = nil, priority: Int, imageID: String? = nil) {
        self.init()
        self.todoTitle = todoTitle
        self.todoContent = todoContent
        self.deadline = deadline
        self.tag = tag
        self.priority = priority
        self.isDone = false
        self.flag = false
        self.imageID = imageID
    }
    
    enum Key: String {
        case todoTitle
        case todoContent
        case deadline
        case tag
        case priority
        case isDone
        case flag
        case imageID
    }
}
