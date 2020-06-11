
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
        
        newExercise.sets.append(defaultSet)
        
        do{
            try realm.write {
                parentRutine?.exercises.append(newExercise)
            }
        }catch{
            print("Faild to add exercise")
        }
        
    }
    
    func renameExercise(at index: Int, newName: String){
        do{
            try realm.write {
                exercises[index].name = newName
            }
        }catch{
            print("Faild to rename exercise" )
        }
    }
    
    func setRestTimer(at index: Int, timeInSecond: Int){
        do{
            try realm.write {
                exercises[index].restTime = timeInSecond
            }
        }catch{
            print("Faild to rename exercise" )
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
    

    
    
    func getExercisesCount() -> Int{
        return exercises.count
    }
    
    func loadExercise() {
        let sorted = parentRutine?.exercises.sorted(byKeyPath: "order", ascending: true)
        exercises = sorted
        
    }
}
