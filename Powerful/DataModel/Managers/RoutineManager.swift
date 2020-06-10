import Foundation
import RealmSwift

class RoutineManager{
    
    var routines: Results<Routine>!
    let realm = try! Realm()
    
    init(willLoadRoutine: Bool) {
        if willLoadRoutine{
            loadRoutine()
        }
    }
    
    
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
    
    func getRoutinesCount() -> Int {
        return routines.count
    }
    
    func loadRoutine() {
        routines = realm.objects(Routine.self)
    }
    
}
