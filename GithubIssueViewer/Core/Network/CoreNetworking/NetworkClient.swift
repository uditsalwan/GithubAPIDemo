//
//  NetworkClient.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import Alamofire
import AlamofireNetworkActivityLogger
import ObjectMapper
import RxSwift

protocol NetworkClientProtocol {
    var baseURL: URL? { get }
    func request<Response: ImmutableMappable>(_ request: APIRequest) -> Single<Response>
    func request<Response: ImmutableMappable>(_ request: APIRequest) -> Single<[Response]>
}

/// Base network class to make API requests
final class NetworkClient : NetworkClientProtocol {
    var baseURL : URL?
    private let dispatch : DispatchQueue
    private let sessionManager : SessionManager
    private let networkConfig : NetworkConfigurationProtocol
    
    let bag = DisposeBag()
    
    init(_ config: NetworkConfigurationProtocol) {
        self.networkConfig = config
        
        let requestHandler = APIRequestHandler(token: config.token)
        self.sessionManager = SessionManager()
        self.sessionManager.adapter = requestHandler
        
        self.dispatch = DispatchQueue(label: "networking", qos: .background, attributes: .concurrent)
        
        if let url = networkConfig.baseURL {
            self.baseURL = URL(string: url)!
        }
        #if DEBUG
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        #endif
    }
    
    func buildGetRequest(_ request: APIRequest) throws -> URLRequest {
        var path = request.path
        guard let baseURL = baseURL else {
            throw APIError.invalidURL
        }
        if !path.hasPrefix(baseURL.absoluteString) {
            switch (request.path.hasPrefix("/"), baseURL.absoluteString.hasSuffix("/")) {
            case (false,false): path = "\(baseURL.absoluteString)/\(path)"
            case (true, true): path = "\(baseURL.absoluteString)/\(path)".replacingOccurrences(of: "///", with: "/")
            default: path = "\(baseURL.absoluteString)\(path)"
            }
        }
        guard let concatenatedURL = URL(string: path) else {
            throw APIError.invalidURL
        }
        guard let urlRequest = try? URLRequest(url: concatenatedURL, method: request.method) else {
            throw APIError.invalidURL
        }
        var mutableRequest = urlRequest
        mutableRequest = try URLEncoding().encode(urlRequest, with: request.parameters)
        return mutableRequest
    }
    
    func request<Response: ImmutableMappable>(_ request: APIRequest)  -> Single<Response> {
        let urlRequest: URLRequest
        do {
            urlRequest = try buildGetRequest(request)
        } catch {
            return Single.error(error)
        }
        
        return Single<Response>.create { [unowned self] single in
            let request = self.sessionManager.request(urlRequest)
                .validate(statusCode: 200...500)
                .validate(contentType: ["application/json", "text/plain"])
                .responseJSON(queue: self.dispatch) { response in
                    #if DEBUG
                    print(response)
                    #endif
                    if let error = response.result.error {
                        single(.error(error))
                        return
                    }
                    
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 204 {
                            single(.error(APIError.noContent))
                        }
                    }
                    
                    guard let data = response.result.value else {
                        single(.error(APIError.emptyResponse))
                        return
                    }
                    
                    if let statusCode = response.response?.statusCode, (200..<300).contains(statusCode) {
                        do {
                            let result = try Mapper<Response>().map(JSONObject: data)
                            single(.success(result))
                        } catch {
                            single(.error(APIError.mappingFailed))
                        }
                    } else {
                        single(.error(APIError.badResponse(code: response.response?.statusCode, desc: nil)))
                    }
            }
            
            return Disposables.create { request.cancel() }
        }
    }
    
    func request<Response: ImmutableMappable>(_ request: APIRequest) -> Single<[Response]> {
        let urlRequest: URLRequest
        do {
            urlRequest = try buildGetRequest(request)
        } catch {
            return Single.error(error)
        }
        return Single<[Response]>.create { single in
            let request = self.sessionManager.request(urlRequest)
                .validate(statusCode: 200...500)
                .validate(contentType: ["application/json"])
                .responseJSON(queue: self.dispatch) { response in
                    #if DEBUG
                    print(response)
                    #endif
                    if let error = response.result.error {
                        single(.error(error))
                        return
                    }
                    
                    guard let data = response.result.value else {
                        single(.error(APIError.emptyResponse))
                        return
                    }
                    
                    if let statusCode = response.response?.statusCode, (200..<300).contains(statusCode) {
                        do {
                            let result = try Mapper<Response>().mapArray(JSONObject: data)
                            single(.success(result))
                        } catch {
                            single(.error(APIError.mappingFailed))
                        }
                    } else {
                        single(.error(APIError.badResponse(code: response.response?.statusCode, desc: nil)))
                    }
            }
            return Disposables.create { request.cancel() }
        }
    }
}
