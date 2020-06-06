import Foundation
import RealmSwift

class RoutineManager{
    
    var routines: Results<Routine>?
    let realm = try! Realm()
    
    func addRoutine(name: String) {
        let newRoutine = Routine()
        newRoutine.name = name
        
        try! realm.write {
            realm.add(newRoutine)
        }
    }
    
    func deleteRoutine(targetIndex: Int){
        if let target = routines?[targetIndex]{
            do{
                try realm.write {
                    realm.delete(target)
                }
            }catch{
                print("Error delete Routine")
            }
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    func loadRoutine() {
        routines = realm.objects(Routine.self)
    }
    
}
