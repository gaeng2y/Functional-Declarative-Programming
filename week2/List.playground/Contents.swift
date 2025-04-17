import Foundation

indirect enum List<E> {
    case node(element: E, next: List<E>)
    case none
}

func seek<E>(_ f: (E) -> Void, on list: List<E>) {
    switch list {
    case .node(let element, let next):
        f(element)
        seek(f, on: next)
    case .none:
        break
    }
}

func map<U, V>(_ f: (U) -> V, on list: List<U>) -> List<V> {
    switch list {
    case let .node(element, next):
        return List<V>.node(element: f(element), next: map(f, on: next))
    case .none:
        return .none
    }
}

func add<E>(_ node: List<E>, on list: List<E>) -> List<E> {
    switch list {
    case let .node(element, next):
        return .node(element: element, next: add(node, on: next))
    case .none:
        return node
    }
}

func filter<E>(_ f: (E) -> Bool, on list: List<E>) -> List<E> {
    switch list {
    case let .node(element, next):
        return f(element) ? .node(element: element, next: filter(f, on: next)) : filter(f, on: next)
    case .none:
        return .none
    }
}

func foldLeft<E>(with value: E, _ f: (E, E) -> E, on list: List<E>) -> E {
    switch list {
    case let .node(element, next):
        return foldLeft(with: f(element, value), f, on: next)
    case .none:
        return value
    }
}

func foldRight<E>(with value: E, _ f: (E, E) -> E, on list: List<E>) -> E {
    switch list {
    case let .node(element, next):
        return f(element, foldRight(with: value, f, on: next))
    case .none:
        return value
    }
}

// MARK: - example
let test = List<Int>.node(element: 1, next: .node(element: 2, next: .node(element: 3, next: .none)))
map({ $0 + 1 }, on: test)
foldLeft(with: 0, +, on: test)
