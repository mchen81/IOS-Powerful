
import Foundation
import RealmSwift

class ExercisingManager{
    
    let realm = try! Realm()
    var exercises: Results<Exercise>!
    
    var parentRutine: Routine? {
        didSet {
            loadExercise()
        }
    }

    func addExercise(name: String, part: String){
        
        let newExercise = Exercise()
        newExercise.name = name
        newExercise.bodyPart = part
        newExercise.order = parentRutine?.exercises.count ?? 0
        
        let defaultSet = SingleSet()
        defaultSet.order = 0
        defaultSet.previous = ""
        
        newExercise.sets.append(defaultSet)
        
        do{
            try realm.write {
                parentRutine?.exercises.append(newExercise)
                // realm.add(newExercise)
            }
        }catch{
            print("Faild to add exercise")
        }
        
    }
    
    func deleteExercise(targetIndex: Int){
        let target = exercises![targetIndex]
        
        do{
            try realm.write{
                realm.delete(target)
            }
        }catch{
            print("Fail to delete an exercise")
        }
        
    }

    func finishExercising(){
        do{
            try realm.write{
                for exercise in exercises {
                    for set in exercise.sets {
                        set.isDone = false
                    }
                }
            }
        }catch{
            print("Fail to finish")
        }
    }
    
    func loadExercise() {
        let sorted = parentRutine?.exercises.sorted(byKeyPath: "order", ascending: true)
        exercises = sorted
        
    }
}
