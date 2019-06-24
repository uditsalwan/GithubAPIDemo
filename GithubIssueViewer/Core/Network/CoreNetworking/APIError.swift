//
//  APIError.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import Foundation

/**
 Error response model used to handle different errors throughout the application.
 
 Errors can be:
 
 - `mappingFailed` -
 Mapping of server response to required model failed
 - `invalidURL` -
 Request builder failed to create a valid URL
 - `emptyResponse` -
 Response received from server does not contain data
 - `noContent` -
 204 Response received from server
 - `badResponse` -
 Error recieved from server or HTTP status code is not in valid range
 - Tag: APIError
 */
public enum APIError : Error {
    case mappingFailed
    case invalidURL
    case emptyResponse
    case noContent
    case badResponse(code: Int?, desc: String?)
}

extension APIError {
    public var code: Int {
        switch self {
        case .badResponse(let code, _):
            return code ?? 0
        case .emptyResponse:
            return -1
        default:
            return 0
        }
    }
    public var description: String? {
        switch self {
        case .badResponse(_, let description):
            return description ?? ""
        default:
            return nil
        }
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badResponse(_, let description):
            return description ?? "Error"
        default:
            return nil
        }
    }
}
