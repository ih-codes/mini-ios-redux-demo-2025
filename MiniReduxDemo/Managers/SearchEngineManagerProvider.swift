//
// SearchEngineManagerProvider.swift
// MiniReduxDemo
// Created on 2025-12-22, 2025. 
//  

import Foundation
import UIKit

protocol SearchEnginesManagerProvider: AnyObject, Sendable {
    @MainActor
    func getOrderedEngines(completion: @escaping @MainActor @Sendable ([SearchEngineModel]) -> Void)
}

@MainActor
final class SearchEnginesManager: SearchEnginesManagerProvider {
    static let shared = SearchEnginesManager()

    private var testDataCounter = 0

    // MARK: SearchEnginesManagerProvider -- Stub methods

    func getOrderedEngines(completion: @escaping @MainActor @Sendable ([SearchEngineModel]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }

            if self.testDataCounter % 2 == 0 {
                completion([])
            } else {
                completion([
                    SearchEngineModel(name: "Engine1"),
                    SearchEngineModel(name: "Engine2"),
                    SearchEngineModel(name: "Engine3")
                ])
            }

            self.testDataCounter += 1
        }
    }
}
