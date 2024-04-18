import Foundation
import CoreData

class DataController: ObservableObject {
    // Responsible for preparing a model
    let container = NSPersistentContainer(name: "FoodModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load data in DataController \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved successfully. WUHU!!!")
        } catch {
            // Handle errors in our database
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addFood(name: String, desc: String, dueDate: Date, isDone: Bool, context: NSManagedObjectContext) {
        let food = Food(context: context)
        food.id = UUID()
        food.date = Date()
        food.name = name
        food.desc = desc // Assigning the value to the "desc" property
        food.dueDate = dueDate
        food.isDone = isDone
        
        save(context: context)
    }
    
    func editFood(food: Food, name: String, desc: String, dueDate: Date, isDone: Bool, context: NSManagedObjectContext) {
        food.date = Date()
        food.name = name
        food.desc = desc // Assigning the value to the "desc" property
        food.dueDate = dueDate
        food.isDone = isDone
        
        save(context: context)
    }
}
