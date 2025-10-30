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
      //  storeData.setValue(Date(), forKey: "createdAt")

        
        do {
            try self.persistentContainer.viewContext.save()
            print("💫 저장 성공!")
        } catch {
            print("☄️ 저장 실패 ㅠwㅠ")
        }
    }
    
    // R
    func readAllData() {
        do {
            let details = try self.persistentContainer.viewContext.fetch(Details.fetchRequest())
            
            for detail in details as [NSManagedObject]{
                if let title = detail.value(forKey: "title") as? String,
                   let author = detail.value(forKey: "author") as? String,
                   let price = detail.value(forKey: "price") as? String {
                    print("제목: \(title), 저자: \(author), 가격: \(price)")
                }
            }
        } catch {
            print("🖥️ 데이터 읽기 실패")
        }
    }
    
    // U
    func getInformation() -> [Details] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Details> = Details.fetchRequest()

        // ✅ 엔티티에 'createdAt' 속성이 있을 때만 정렬 적용 (없으면 크래시 방지)
        let entity = Details.entity()
        if entity.attributesByName.keys.contains("createdAt") {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        }

        do {
            let list = try context.fetch(fetchRequest)

            // ✅ 정렬을 못 걸었을 때(= createdAt 없음)만 임시 역순으로 보여주기
            if fetchRequest.sortDescriptors?.isEmpty ?? true {
                return Array(list.reversed())
            } else {
                return list
            }
        } catch {
            print("Fetch failed: \(error)")
            return []
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
    
    
    // 전체삭제 로직
    func deleteAllDetails() {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Details> = Details.fetchRequest()
        do {
            let all = try context.fetch(request)
            all.forEach { context.delete($0) }
            try context.save()
            print("✅ 전체 삭제 성공")
        } catch {
            print("❌ 전체 삭제 실패: \(error)")
        }
    }

 
 
}
