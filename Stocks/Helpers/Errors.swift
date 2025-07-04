//
//  Errors.swift
//  Stocks
//
//  Created by Дмитрий К on 08.05.2025.
//

import Foundation

enum Errors: String, Error {
    case smthBad = "Just to know"
    case invalidURL = "invalid URL"
    case invalidResponse = "invalid response"
    case noData = "no data"
    case decodingError = "error decoding data"
}
