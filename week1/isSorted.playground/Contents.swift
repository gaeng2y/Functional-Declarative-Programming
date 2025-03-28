import UIKit

class List<T> {
    let value: T
    let next: List<T>?
    
    init(value: T, next: List<T>?) {
        self.value = value
        self.next = next
    }
}

func isSorted<T>(list: List<T>, order: (T, T) -> Bool) -> Bool {
    switch list.next {
    case .none:
        return true
    case .some(let nextList):
        return order(list.value, nextList.value)
        && isSorted(list: nextList, order: order)
    }
}

isSorted(list: .init(value: 1, next: .init(value: 2, next: nil)), order: <)
