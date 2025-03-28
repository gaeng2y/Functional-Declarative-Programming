import UIKit

func fibo(_ i: Int) -> Int {
    switch i {
    case 0: return 0
    case 1: return 1
    default: return fibo(i - 1) + fibo(i - 2)
    }
}
