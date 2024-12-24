//
//  WeatherDataContainer.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

enum WeatherDataContainer<T> {
    case loading
    case error(String)
    case loaded(T)
}
