import Foundation

enum DataState<T> {
    case loading
    case success(T)
    case error(String)
}