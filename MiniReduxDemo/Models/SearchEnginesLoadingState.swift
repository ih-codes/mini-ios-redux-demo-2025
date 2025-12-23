//
// SearchEnginesLoadingState.swift
// MiniReduxDemo
// Created on 2025-12-22, 2025. 
//  

enum SearchEnginesLoadingState: Equatable, Codable {
    case notStarted
    case loading
    case succeeded([SearchEngineModel])
    case failed(LoadSearchEnginesError)
}
