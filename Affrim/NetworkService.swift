import Foundation
import Combine

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    enum NetworkError: LocalizedError {
        case invalidURL
        case noData
        case decodingError
        case networkError(String)
        case serverError(Int, String)
        case timeoutError
        case connectionError
        case sslError
        case unknownError(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .noData:
                return "No data received"
            case .decodingError:
                return "Error parsing server response. Please try again later."
            case .networkError(let message):
                return "Network error: \(message)"
            case .serverError(let code, let message):
                return "Server error (\(code)): \(message)"
            case .timeoutError:
                return "Connection timed out. Please try again."
            case .connectionError:
                return "Failed to connect to server. Please check your connection."
            case .sslError:
                return "Secure connection failed. Please try again."
            case .unknownError(let message):
                return "An unexpected error occurred: \(message)"
            }
        }
    }
    
    func makeRequest<T: Codable>(
        endpoint: String,
        baseURL: String = "http://localhost:3000",
        method: HTTPMethod = .GET,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) -> AnyPublisher<DataState<T>, Never> {
        
        return Future<DataState<T>, Never> { [weak self] promise in
            Task {
                await promise(.success(.loading))
                
                do {
                    let result: T = try await self?.performRequest(
                        endpoint: endpoint,
                        baseURL: baseURL,
                        method: method,
                        body: body,
                        headers: headers,
                        responseType: responseType
                    ) ?? {
                        throw NetworkError.unknownError("NetworkService instance is nil")
                    }()
                    
                    await promise(.success(.success(result)))
                } catch {
                    let networkError = self?.mapError(error) ?? NetworkError.unknownError(error.localizedDescription)
                    await promise(.success(.error(networkError.localizedDescription)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func performRequest<T: Codable>(
        endpoint: String,
        baseURL: String,
        method: HTTPMethod,
        body: [String: Any]?,
        headers: [String: String]?,
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authorization header if access token exists
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        // Add custom headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add request body
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw NetworkError.networkError("Failed to serialize request body")
            }
        }
        
        // Set timeout
        request.timeoutInterval = 30.0
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode >= 400 {
                    if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errorMessage = errorData["message"] as? String {
                        throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
                    } else {
                        throw NetworkError.serverError(httpResponse.statusCode, "Server error")
                    }
                }
            }
            
            let decodedResponse = try JSONDecoder().decode(responseType, from: data)
            return decodedResponse
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw mapError(error)
        }
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut:
                return .timeoutError
            case .cannotConnectToHost, .cannotFindHost, .networkConnectionLost:
                return .connectionError
            case .notConnectedToInternet:
                return .networkError("Check your internet connection and try again")
            case .secureConnectionFailed:
                return .sslError
            default:
                return .networkError(urlError.localizedDescription)
            }
        }
        
        if error is DecodingError {
            return .decodingError
        }
        
        return .unknownError(error.localizedDescription)
    }
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}