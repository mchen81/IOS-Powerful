
import Foundation
import CoreData

class ExercisingManager{
    var parentRutine: Routine
    var exercises: [Exercise]
    var coreDataContext: NSManagedObjectContext
    
    init(_ parent: Routine, _ context: NSManagedObjectContext) {
        self.coreDataContext = context
        self.parentRutine = parent
        exercises = parent.exercises?.allObjects as! [Exercise]
    }
    
    func addExercise(name: String, part: String){
        let newExercise = Exercise(context: coreDataContext)
        newExercise.name = name
        newExercise.bodypart = part
        newExercise.parentRoutine = parentRutine
        
        let set = SingleSet(context: coreDataContext)
        set.previous = "0.0 * 0.0"
        set.parentExercise = newExercise
        set.reps = 0
        set.weight = 0
        set.done = false
        
        exercises.append(newExercise)
        saveExercise()
    }
    
    func deleteExercise(targetIndex: Int){
        coreDataContext.delete(exercises[targetIndex])
        exercises.remove(at: targetIndex)
        saveExercise()
    }
    
    func deleteSingleSet(targetExerciseIndex: Int, targetSetIndex: Int){
        var sets = exercises[targetExerciseIndex].sets?.allObjects as! [SingleSet]
        sets.remove(at: targetSetIndex)
        exercises[targetExerciseIndex].sets = NSSet(array: sets)
        saveExercise()
    }
    
    func addSingleSet(targetExerciseIndex: Int){
        var sets = exercises[targetExerciseIndex].sets?.allObjects as! [SingleSet]
        let lastSet = sets.last
        let newSet = SingleSet(context: coreDataContext)
        newSet.previous = lastSet?.previous ?? "no previous"
        newSet.weight = lastSet?.weight ?? 0
        newSet.reps = lastSet?.reps ?? 0
        sets.append(newSet)
        exercises[targetExerciseIndex].sets = NSSet(array: sets)
        saveExercise()
    }
    
    func saveExercise() {
        do {
            try coreDataContext.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadExercise() {
        let request : NSFetchRequest<Exercise> = Exercise.fetchRequest()
        do{
            exercises = try coreDataContext.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
    }
}
