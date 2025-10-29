//
//  CoreDataManager.swift
//  bookSearchApp
//
//  Created by jyeee on 10/29/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    

       lazy var persistentContainer: NSPersistentContainer = {

           let container = NSPersistentContainer(name: "BookSearchApp")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }


   
    // C
    func createData(title: String, author: String, price: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Details", in: self.persistentContainer.viewContext) else { return }
        
        let storeData = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
        
        storeData.setValue(title, forKey: "title")
        storeData.setValue(author, forKey: "author")
        storeData.setValue(price, forKey: "price")
        
        do {
            try self.persistentContainer.viewContext.save()
            print("💫 저장 성공!")
        } catch {
            print("☄️ 저장 실패 ㅠwㅠ")
        }
    }
    
    // D
    func deleteData(title: String) {
        let fetchRequest = Details.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let result = try self.persistentContainer.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                self.persistentContainer.viewContext.delete(data)
            }
            
            try self.persistentContainer.viewContext.save()
            print("데이터 삭제 성공")
        } catch {
            print("데이터 삭제 실패")
        }
   
    }
 
 
}
