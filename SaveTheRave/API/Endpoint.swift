//
//  Endpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

protocol Endpoint {
	var url: URL { get }
	var method: String { get }
	var headers: [String: String] { get }
	var body: Data? { get }
	
	func sendRequest(completion: @escaping (Result<Data, Error>) -> Void)
}

extension Endpoint {
	
	var headers: [String: String] {
		["Content-Type": "application/json"]
	}
	
	func sendRequest(completion: @escaping (Result<Data, Error>) -> Void) {
		var request = URLRequest(url: url, timeoutInterval: Double.infinity)
		request.httpMethod = method
		headers.forEach { key, value in
			request.addValue(value, forHTTPHeaderField: key)
		}
		request.httpBody = body
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				let error = NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
				completion(.failure(error))
				return
			}
			
			completion(.success(data))
		}
		
		task.resume()
	}
}
