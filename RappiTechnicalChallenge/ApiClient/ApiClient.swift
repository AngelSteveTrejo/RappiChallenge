//
//  ApiClient.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/25/19.
//

import Foundation
import UIKit

/// Enum that allows validate the code response which the web Services returns.
///
/// - success: It allows to validate that the service response code is successful
enum StatusCode: Int {
    case success = 200
}

/// Enumerator that orders the possible errors of a request
///
/// - apiError: Api Error.
/// - invalidEndPoint: Invalid End Point.
/// - invalidResponse: The response is wrong.
/// - noData: There is not info.
/// - decodeError: Error data decoding.
enum ApiServiceError: Error {
    case apiError
    case invalidEndPoint
    case invalidResponse
    case noData
    case decodeError
}

/// Allows handling requests to web services within the application.
final class ApiClient {
    /// Singleton that allows to share info of WebServices.
    static let shared = ApiClient()
    /// Defines behavior and policies for a URL session.
    private let configuration = URLSessionConfiguration.default
    /// The shared singleton session object for URL session.
    private var session = URLSession.shared
    
    private init() {
        session = URLSession(configuration: configuration)
    }
    
    /// Allows handling requests to web services within the application.
    ///
    /// - Parameters:
    ///   - url: URL service
    ///   - completion: The response or service information.
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, ApiServiceError>) -> Void) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndPoint))
            return
        }
        guard let url = urlComponents.url else {
            completion(.failure(.invalidResponse))
            return
        }
        var request = URLRequest(url: url)
        request.addValue(Constants.Api.zomatoKey, forHTTPHeaderField: Constants.Api.zomatoHeader)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        session.dataTask(with: request) { (data, response, _) in
            if let response = response, let data = data {
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    statusCode == StatusCode.success.rawValue else {
                        completion(.failure(.invalidResponse))
                        return
                }
                do {
                    let decodedModel = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(decodedModel))
                } catch {
                    print("error \(error.localizedDescription)")
                    completion(.failure(.decodeError))
                }
            } else {
                completion(.failure(.apiError))
            }
            }.resume()
    }
}
