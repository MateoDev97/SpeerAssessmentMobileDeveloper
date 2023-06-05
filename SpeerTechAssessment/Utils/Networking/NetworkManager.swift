//
//  NetworkManager.swift
//  SpeerTechAssessment
//
//  Created by Brian Ortiz on 2023-06-05.
//


import Foundation
import Combine

class NetworkManager {
    
    private var baseUrl = "https://api.github.com/"

    public enum API_PATH: String {
        case USERS = "users/"
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = NetworkManager()
    
    func genericApiRequest<T: Decodable>(_ type: T.Type, method: HttpMethod = .get, path: API_PATH, extraPath: String = "") -> Future<T, Error> {
                
        guard let url = URL(string: baseUrl + path.rawValue + extraPath) else {
            return Future { promise in
                promise(.failure(NetworkError.invalidURL))
            }
        }
        
        var request = URLRequest(url: url)
                
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // 30 seconds timeout
        
        let session = URLSession(configuration: configuration)
        
        return Future<T, Error> { [weak self] promise in
            
            guard let self = self else {
                return promise(.failure(NetworkError.unknown))
            }
            
            session.dataTaskPublisher(for: request)
                .map { $0.data }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { (completion) in
                        if case let .failure(error) = completion {
                            switch error {
                            case let decodingError as DecodingError:
                                promise(.failure(decodingError))
                            case let apiError as NetworkError:
                                promise(.failure(apiError))
                            case let urlError as URLError:
                                promise(.failure(urlError))
                            default:
                                promise(.failure(NetworkError.unknown))
                            }
                        }
                    },
                    receiveValue: { promise(.success($0)) }
                )
                .store(in: &self.cancellables)
        }
        
    }
    
    
}

enum HttpMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}

