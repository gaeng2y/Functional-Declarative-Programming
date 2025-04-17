import UIKit

indirect enum Tree<E: Comparable> {
    case node(element: E, left: Tree<E>, right: Tree<E>)
    case none
}

func traversePreorder<E>(_ f: (E) -> Void, in tree: Tree<E>) {
    switch tree {
    case let .node(element, left, right):
        f(element)
        
        switch left {
        case .none:
            break
        default:
            traversePreorder(f, in: left)
        }
        
        switch right {
        case .none:
            break
        default:
            traversePreorder(f, in: right)
        }
    case .none:
        break
    }
}

func traverseInorder<E>(_ f: (E) -> Void, in tree: Tree<E>) {
    switch tree {
    case let .node(element, left, right):
        switch left {
        case .none:
            break
        default:
            traverseInorder(f, in: left)
        }
        
        f(element)
        
        switch right {
        case .none:
            break
        default:
            traversePreorder(f, in: right)
        }
    case .none:
        break
    }
}

func traversePostorder<E>(_ f: (E) -> Void, in tree: Tree<E>) {
    switch tree {
    case let .node(element, left, right):
        switch left {
        case .none:
            break
        default:
            traverseInorder(f, in: left)
        }
        
        switch right {
        case .none:
            break
        default:
            traversePreorder(f, in: right)
        }
        
        f(element)
    case .none:
        break
    }
}

func add<E>(_ value: E, in tree: Tree<E>) -> Tree<E> {
    switch tree {
    case .none:
        return Tree.node(element: value, left: .none, right: .none)
        
    case let .node(element, left, right):
        if value < element {
            return .node(element: element, left: add(value, in: left), right: right)
        } else if value > element {
            return .node(element: element, left: left, right: add(value, in: right))
        } else {
            return tree
        }
    }
}

func map<U, V>(_ f: (U) -> V, in tree: Tree<U>) -> Tree<V> {
    switch tree {
    case let .node(element, left, right):
        return .node(
            element: f(element),
            left: map(f, in: left),
            right: map(f, in: right)
        )
    case .none:
        return .none
    }
}

func getMin<E>(_ tree: Tree<E>) -> Tree<E> {
    switch tree {
    case .none:
        return .none
    case let .node(element, left, right):
        switch left {
        case .none:
            return tree
        case .node:
            return getMin(left)
        }
    }
}

func getMax<E>(_ tree: Tree<E>) -> Tree<E> {
    switch tree {
    case .none:
        return .none
    case let .node(element, left, right):
        switch right {
        case .none:
            return tree
        case .node:
            return getMax(right)
        }
    }
}

func getHeight<E>(_ tree: Tree<E>) -> Int {
    switch tree {
    case .none:
        return 0
    case let .node(_, left, right):
        return max(getHeight(left), getHeight(right)) + 1
    }
}

func getNodeCount<E>(_ tree: Tree<E>) -> Int {
    switch tree {
    case .none:
        return 0
    case let .node(_, left, right):
        return 1 + getNodeCount(left) + getNodeCount(right)
    }
}

let test = Tree<String>.node(
    element: "A",
    left: .node(
        element: "B",
        left: .node(element: "D", left: .none, right: .none),
        right: .node(element: "E", left: .none, right: .none)
    ),
    right: .node(element: "C", left: .none, right: .none)
)

//traversePreorder({ print($0) }, in: test)
//traverseInorder({ print($0) }, in: test)
//traversePostorder({ print($0) }, in: test)
add("F", in: test)
