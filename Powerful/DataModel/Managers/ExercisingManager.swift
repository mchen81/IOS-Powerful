
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
    
    func addSingleSet(targetExerciseIndex: Int){
        let exercise = exercises[targetExerciseIndex]
        
        var lastWeight: Float = 0
        var lastReps: Int = 0
        
        if let lastSet = exercise.sets.last {
            lastWeight = lastSet.weight
            lastReps = lastSet.reps
        }
        
        let newSet = SingleSet()
        newSet.order = exercise.sets.count
        newSet.reps = lastReps
        newSet.weight = lastWeight
        
        do{
            try realm.write{
                exercise.sets.append(newSet)
            }
        }catch{
            print("Fail to delete an exercise")
        }

    }
    
    func deleteSingleSet(targetExerciseIndex: Int, targetSetIndex: Int){
        let exercise = exercises[targetExerciseIndex]
        
        do{
            try realm.write{
                for set in exercise.sets {
                    if set.order > targetSetIndex {
                        set.order = set.order - 1
                    }
                }
                exercise.sets.remove(at: targetSetIndex)
            }
        }catch{
            print("Fail to delete an exercise")
        }
    }
    
    func updateSet(exerciseIndex: Int, setIndex: Int, newWeight: Float?, newReps: Int?, done: Bool = false){
        let exercise = exercises[exerciseIndex]
        let set = exercise.sets[setIndex]
        do{
            try realm.write{
                set.isDone = done
                if let w = newWeight {
                    set.weight = w
                }
                
                if let r = newReps {
                    set.reps = r
                }
                
            }
        }catch{
            print("Fail to delete an exercise")
        }
        
    }
    
    
    func loadExercise() {
        
        let sorted = parentRutine?.exercises.sorted(byKeyPath: "order", ascending: true)
        exercises = sorted
        
    }
}
