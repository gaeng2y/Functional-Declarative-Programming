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

func multiply(x: Int, y: Int) -> Int {
    x * y
}

func printFormula(
    with Formula: String,
    closure: (Int, Int) -> Int)
) -> (Int, Int) -> Int {
    return { x, y in
            print("\(formula) = \(closure(x,y))")
    }
}

func printMultiply(with num: Int, from start: Int, until end: Int) {
    guard start <= end else {
        return
    }
    printMultiply(with: num, from: start, until: end)
}
