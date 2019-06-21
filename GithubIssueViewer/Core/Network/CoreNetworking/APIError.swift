//
//  APIError.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import Foundation

public enum APIError : Error {
    case mappingFailed
    case invalidURL
    case emptyResponse
    case noContent
    case nonZeroResponse(code: Int, desc: String?)
    case badResponse(code: Int?, desc: String?)
    case unavailableForGuest
}

extension APIError {
    public var code: Int {
        switch self {
        case .nonZeroResponse(let code, _):
            return code
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
        case .nonZeroResponse(_, let description):
            return description
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
        case .nonZeroResponse(_, let description):
            return description
        case .badResponse(_, let description):
            return description ?? "Error"
        default:
            return nil
        }
    }
}
