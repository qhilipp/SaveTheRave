//
//  Endpoint.swift
//  SaveTheRave
//
//  Created by Philipp Kathöfer on 11.01.2025.
//

import Foundation

protocol Endpoint {
	var baseURL: String { get }
	var path: String { get }
	var url: URL { get }
	var method: String { get }
	var headers: [String: String] { get set }
	var parameters: [String: Any]? { get }
	var debug: Bool { get }
	
	func sendRequest(completion: @escaping (Result<Data, Error>) -> Void)
}

extension Endpoint {
	
	var baseURL: String {
		"http://169.231.139.207:8000/"
	}
	
	var parameters: [String: Any]? { nil }
	
	var url: URL {
		URL(string: "\(baseURL)\(path)/")!
	}
	
	var debug: Bool { true }
	
	var cURL: String {
		var curlCommand = "curl"
			
			curlCommand += " \(url.absoluteString)"
			
			if method.uppercased() != "GET" {
				curlCommand += " -X \(method)"
			}
			
			for (key, value) in headers {
				curlCommand += " -H '\(key): \(value)'"
			}
			
			if let parameters, let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: []), let bodyString = String(data: bodyData, encoding: .utf8) {
				curlCommand += " --data '\(bodyString)'"
			}
			
			return curlCommand
	}
	
	func sendRequest(completion: @escaping (Result<Data, Error>) -> Void) {
		
		if debug {
			print(cURL)
		}
		
		var request = URLRequest(url: url, timeoutInterval: Double.infinity)
		request.httpMethod = method
		request.allHTTPHeaderFields = headers
		
		if let parameters, let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
			request.httpBody = bodyData
		}
		
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
			
			if debug {
				print(String(data: data, encoding: .utf8)!)
			}
			
			completion(.success(data))
		}
		
		task.resume()
	}
}
