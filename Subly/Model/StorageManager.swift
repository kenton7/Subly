//
//  StorageManager.swift
//  Subly
//
//  Created by Илья Кузнецов on 31.01.2021.
//

import Foundation
import RealmSwift

//экзамепляр класса realm
let realm = try! Realm()

class StorageManager {
    //записываем объект в БД Realm
    static func saveObject(_ place: Content) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    //метод удаления объекта
    static func deleteObject(_ place: Content) {
        
        try! realm.write {
            realm.delete(place)
        }
        
    }
}
