import Foundation


class TimerHelper{
    
    static func secToTimeString(_ totalSec: Int) -> String {
        var hour = 0
        var min = 0
        var sec = 0
        
        if totalSec >= 60 {
            min = Int(totalSec / 60)
            if min >= 60 {
                hour = Int(min / 60)
                min = min % 60
            }
            sec = totalSec % 60
        }else{
            sec = totalSec
        }
        return hour == 0 ? String(format: "%02d:%02d", min, sec) : String(format: "%d:%02d:%02d", hour, min, sec)
        
    }
    
    
}
