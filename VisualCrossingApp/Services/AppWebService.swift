//
//  AppWebService.swift
//
//  Created by Saad Umar on 9/23/22.
//

import Foundation

/*
 Class AppWebService and enums will be part of App Swift Package
 */
public enum AppWebServiceError: Error {
    case invalidURL
    case failedRequest(json: Any?, response: HTTPURLResponse)
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol AppWebServiceDelegate: AnyObject {
    var defaultHeaders: [String: String] { get }
}

public class AppWebService {

    private var httpMethod: HttpMethod?
    private var url: String?
    private var httpHeaders: [String:String]?
    private var timeOutInterval: TimeInterval = 190.0
    private var httpBody: Data?
    private var ignoreDefaultHeaders: Bool = false
    private static var delegate: AppWebServiceDelegate?
    
    public static func configure(delegate: AppWebServiceDelegate) {
        AppWebService.delegate = delegate
    }
    
    public init(ignoreDefaultHeaders: Bool = false) {
        self.ignoreDefaultHeaders = ignoreDefaultHeaders
    }
    
    public func setMethod(httpMethod: HttpMethod) -> AppWebService {
        self.httpMethod = httpMethod
        return self
    }
   
    public func setURL(url: String) -> AppWebService {
        self.url = url
        return self
    }

    public func setHeaders(headers: [String:String]) -> AppWebService {

        self.httpHeaders = headers

        for (key, value) in defaultHeaders() {
            self.httpHeaders?[key] = value
        }

        return self
    }

    private func defaultHeaders() -> [String:String] {
        if self.ignoreDefaultHeaders {
            return [:]
        }
        return AppWebService.delegate?.defaultHeaders ?? [:]
    }

    public func setTimeOutInterval(timeOut: TimeInterval) -> AppWebService {
        self.timeOutInterval = timeOut
        
        return self
    }
    
    public func setBody(body: Any) -> AppWebService {
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        self.httpBody = bodyData
        return self
    }
    
    private func getUrlRequest() throws -> URLRequest {
        guard let url = URL(string: self.url ?? "") else {
            throw AppWebServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        if self.httpHeaders == nil {
            self.httpHeaders = self.defaultHeaders()
        }
        
        if let headers = self.httpHeaders {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
       
        request.httpMethod = self.httpMethod?.rawValue
        request.timeoutInterval = self.timeOutInterval
        request.httpBody = self.httpBody

        return request
    }
    
    //IFF iOS 14.0 and below
    private func makeRequest <T: Decodable> (type: T.Type, request: URLRequest, completion: @escaping (T?, Error?) -> Void) {

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    completion(nil, AppWebServiceError.failedRequest(json: json, response: httpResponse))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(type, from: data)
                    completion(result, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }.resume()
    }
    
    private func makeRequest (request: URLRequest, completion: @escaping (Any?, Error?) -> Void) {

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    completion(nil, AppWebServiceError.failedRequest(json: json, response: httpResponse))
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    completion(result, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }.resume()
    }
    
    //For Parsed Data
    public func makeRequest <T: Decodable> (type: T.Type) async throws -> T {
        var request: URLRequest!
        var dataResponse: (data: Data, response: URLResponse)?

        do {
            request = try getUrlRequest()
        } catch {
            throw AppWebServiceError.invalidURL
        }

        if #available(iOS 15.0, *) {
            dataResponse = try await URLSession.shared.data(for: request)
            
            if let httpResponse = dataResponse?.response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                if let data = dataResponse?.data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    throw AppWebServiceError.failedRequest(json: json, response: httpResponse)
                }
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(type, from: dataResponse?.data ?? Data())
                return result
            } catch {
                throw error
            }
            
        } else {
            // Fallback on earlier versions
            do {
                return try await withCheckedThrowingContinuation({ continuation in
                    makeRequest(type: type, request: request) { result, error in
            
                        if let err = error {
                            continuation.resume(throwing: err)
                            return
                        }

                        if let res = result {
                            continuation.resume(returning: res)
                        }
                    }
                })
            } catch {
                throw error
            }
        }
        
    }
    
    //For Raw data -
    public func makeRequest() async throws -> Any {
        var request: URLRequest!
        var dataResponse: (data: Data, response: URLResponse)?

        do {
            request = try getUrlRequest()
        } catch {
            throw AppWebServiceError.invalidURL
        }
        
        if #available(iOS 15.0, *) {
            dataResponse = try await URLSession.shared.data(for: request)
            
            if let httpResponse = dataResponse?.response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                if let data = dataResponse?.data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    throw AppWebServiceError.failedRequest(json: json, response: httpResponse)
                }
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: dataResponse?.data ?? Data(), options: .fragmentsAllowed)
                 return json
            } catch {
                throw error
            }
        } else {
            // Fallback on earlier versions
            do {
                return try await withCheckedThrowingContinuation({ continuation in
                    makeRequest(request: request) { result, error in
                        if let err = error {
                            continuation.resume(throwing: err)
                            return
                        }
                        
                        if let res = result {
                            continuation.resume(returning: res)
                        }
                    }
                })
            } catch {
                throw error
            }
        }
    }
}
