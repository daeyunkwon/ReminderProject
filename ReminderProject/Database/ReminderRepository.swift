//
//  RemindarRepository.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/8/24.
//

import UIKit

import RealmSwift

class ReminderRepository {
    
    private let realm = try! Realm()
    
    
    
    
    func fetchAllFolder() -> [Folder] {
        let result = realm.objects(Folder.self).sorted(byKeyPath: Folder.Key.regDate.rawValue, ascending: true)
        return Array(result)
    }
    
    func fetchAllReminder() -> [Reminder] {
        let result = realm.objects(Reminder.self)
        return Array(result)
    }
    
    func createReminder(data: Reminder, completion: @escaping (Result<Reminder, ReminderRealmError>) -> Void) {
        do {
            try realm.write {
                realm.add(data)
                completion(.success(data))
            }
            
        } catch {
            print(error)
            completion(.failure(ReminderRealmError.failedToWrite))
        }
    }
    
    func createReminder(data: Reminder, folder: Folder, completion: @escaping (Result<Reminder, ReminderRealmError>) -> Void) {
        do {
            try realm.write {
                folder.reminderList.append(data)
                completion(.success(data))
            }
            
        } catch {
            print(error)
            completion(.failure(ReminderRealmError.failedToWrite))
        }
    }
    
    func createFolder(folderName: String, completion: @escaping (Result<Folder, ReminderRealmError>) -> Void) {
        let folder = Folder(name: folderName)
        
        do {
            try realm.write {
                realm.add(folder)
                completion(.success(folder))
            }
        } catch {
            print(error)
            completion(.failure(.failedToWrite))
        }
    }
    
    func updateReminder(reminder: Reminder, title: String, contentText: String?, deadline: Date?, tag: String?, priority: Int, completion: @escaping (Result<Reminder, ReminderRealmError>) -> Void) {
        do {
            try realm.write {
                reminder.todoTitle = title
                reminder.todoContent = contentText
                reminder.deadline = deadline
                reminder.tag = tag
                reminder.priority = priority
                
                completion(.success(reminder))
            }
        } catch {
            print(error)
            completion(.failure(ReminderRealmError.failedToWrite))
        }
    }
    
    func deleteReminder(reminder: Reminder, completion: @escaping (Result<Bool, ReminderRealmError>) -> Void) {
        do {
            try realm.write {
                ImageFileManager.shared.removeImageFromDocument(filename: "\(reminder.id)")
                realm.delete(reminder)
                completion(.success(true))
            }
        } catch {
            print(error)
            completion(.failure(.failedToDelete))
        }
    }
    
    
    
    
    
}
