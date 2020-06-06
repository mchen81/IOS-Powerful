import Foundation
import RealmSwift

class Routine: Object{
    @objc dynamic var name: String = ""
    
    var exercises = List<Exercise>()
}

class Exercise: Object{
    @objc dynamic var order: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var bodyPart: String?
    @objc dynamic var restTime: Int = 0
    
    var sets =  List<SingleSet>()
    var parentRoutine = LinkingObjects(fromType: Routine.self, property: "exercises")
}

class SingleSet: Object{
    @objc dynamic var order: Int = 0
    @objc dynamic var previous: String? = nil
    @objc dynamic var reps: Int = 0
    @objc dynamic var weight: Float = 0
    @objc dynamic var isDone: Bool = false
    
    var parentExercise = LinkingObjects(fromType: Exercise.self, property: "sets")
}
