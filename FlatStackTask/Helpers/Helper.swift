import Foundation

class Helper {
    
    static func convertNumber(number: Int) -> String {
        
        var stringNumber = String(number)
        
        for index in stride(from: stringNumber.count, through: 1, by: -1) {
            
            if index % 3 == 0 {
                
                stringNumber.insert(" ", at: stringNumber.index(stringNumber.startIndex, offsetBy: stringNumber.count - index))
            }
        }
        
        return stringNumber
    }
}
