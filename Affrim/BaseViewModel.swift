import Foundation
import Combine

class BaseViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        cancellables.removeAll()
    }
    
    func emitResultsToPublisher<T>(
        publisher: CurrentValueSubject<DataState<T>?, Never>,
        networkRequest: () -> AnyPublisher<DataState<T>, Never>
    ) {
        networkRequest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dataState in
                publisher.send(dataState)
            }
            .store(in: &cancellables)
    }
    
    func emitResultsToPublished<T>(
        publishedProperty: inout Published<DataState<T>?>.Publisher,
        networkRequest: () -> AnyPublisher<DataState<T>, Never>
    ) {
        networkRequest()
            .receive(on: DispatchQueue.main)
            .sink { dataState in
                // This approach requires the Published property to be manually updated
                // Better to use the CurrentValueSubject approach above
            }
            .store(in: &cancellables)
    }
}

// MARK: - StatePublisher for cleaner state management
@propertyWrapper
class StatePublisher<T> {
    private let subject = CurrentValueSubject<DataState<T>?, Never>(nil)
    
    var wrappedValue: DataState<T>? {
        get { subject.value }
        set { subject.send(newValue) }
    }
    
    var projectedValue: AnyPublisher<DataState<T>?, Never> {
        subject.eraseToAnyPublisher()
    }
    
    func publisher() -> CurrentValueSubject<DataState<T>?, Never> {
        return subject
    }
}