//
//  ApiKeyProvider.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

protocol ApiKeyProviderProtocol {
    var apiKey: String { get }
}

final class ApiKeyProvider: ApiKeyProviderProtocol {
    var apiKey: String = "3e5afd29dd22c6c30c3f02832b405045"
}
