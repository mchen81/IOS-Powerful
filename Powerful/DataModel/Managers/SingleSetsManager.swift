import Foundation
import RealmSwift

class SingleSetsManager{
    
    let realm = try! Realm()
    var sets: Results<SingleSet>!
    
    var parentExercise: Exercise? {
        didSet{
            loadItems()
        }
    }
    
    func addSingleSet(){
        
        var lastWeight: Float = 0
        var lastReps: Int = 0
        
        if let lastSet = sets.last {
            lastWeight = lastSet.weight
            lastReps = lastSet.reps
        }
        
        let newSet = SingleSet()
        newSet.order = sets.count
        newSet.reps = lastReps
        newSet.weight = lastWeight
        
        do{
            try realm.write{
                parentExercise?.sets.append(newSet)
            }
        }catch{
            print("Fail to add a set")
        }
        
    }
    
    func deleteSingleSet(at index: Int){
        do{
            try realm.write{
                for set in sets {
                    if set.order > index {
                        set.order = set.order - 1
                    }
                }
                parentExercise?.sets.remove(at: index)
            }
        }catch{
            print("Fail to delete an exercise")
        }
    }
    
    func updateSet(at index: Int, newWeight: Float?, newReps: Int?){
        let set = sets[index]
        do{
            try realm.write{
                if let w = newWeight {
                    set.weight = w
                }
                
                if let r = newReps {
                    set.reps = r
                }
            }
        }catch{
            print("Fail to update a set")
        }
    }
    
    func setDone(at index: Int, is done: Bool){
        let set = sets[index]
        do{
            try realm.write{
                set.isDone = done
            }
        }catch{
            print("Fail to done a set")
        }
    }
    
    func loadItems(){
        let sorted = parentExercise?.sets.sorted(byKeyPath: "order", ascending: true)
        sets = sorted
    }
}
