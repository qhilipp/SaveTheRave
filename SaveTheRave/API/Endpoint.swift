//
//  Endpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

protocol Endpoint {
	var baseURL: URL { get }
	var path: String { get }
	var method: String { get }
	var headers: [String: String]? { get }
	var body: Data? { get }
	
	func createRequest() -> URLRequest
}

extension Endpoint {
	var baseURL: URL {
		return URL(string: "http://0.0.0.0:8000")!
	}
	
	func createRequest() -> URLRequest {
		var request = URLRequest(url: baseURL.appendingPathComponent(path))
		request.httpMethod = method
		headers?.forEach { key, value in
			request.setValue(value, forHTTPHeaderField: key)
		}
		request.httpBody = body
		return request
	}
	
	func sendRequest(completion: @escaping (Result<Data, Error>) -> Void) {
			let request = createRequest()
			
			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				if let error = error {
					completion(.failure(error))
					return
				}
				
				guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
					let statusError = NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
					completion(.failure(statusError))
					return
				}
				
				if let data = data {
					completion(.success(data))
				} else {
					let noDataError = NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])
					completion(.failure(noDataError))
				}
			}
			
			task.resume()
		}
}
