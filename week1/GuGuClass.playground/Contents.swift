import UIKit

func printTimesTable(num: Int, until max: Int) -> String {
    let multiplicationLines = (1...max).map { index in
        "\(num) x \(index) = \(num * index)"
    }
    
    return multiplicationLines.joined(separator: "\n")
}

//func multiply(_ q: Int) -> String {
//    multiplying(num: q, until: 9)
//}
//
//func multiplying(num: Int, until limit: Int, initialValue value: Int = 1) -> String {
//    guard value <= limit else {
//        return ""
//    }
//    
//    let currentResult = "\(num) * \(value) = \(num * value)\n"
//    let nextResults = multiplying(num: num, until: limit, initialValue: value + 1)
//    
//    return currentResult + nextResults
//}

// 사용 예시
printTimesTable(num: 2, until: 9)
