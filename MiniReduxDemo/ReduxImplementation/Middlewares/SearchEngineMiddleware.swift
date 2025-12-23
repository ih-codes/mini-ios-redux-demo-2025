// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

@MainActor
final class SearchEnginesMiddleware {
    private let logger: Logger
    private let searchEnginesManager: SearchEnginesManagerProvider

    init(searchEnginesManager: SearchEnginesManagerProvider = SearchEnginesManager.shared,
         logger: Logger = DefaultLogger.shared) {
        self.logger = logger
        self.searchEnginesManager = searchEnginesManager
    }

    lazy var searchEnginesProvider: Middleware<AppState> = { [self] state, action in
        // IHC - Why doesn't the compiler think `didTapLoadEnginesButton` is a member of `SearchEnginesActionType`?
//        guard let action = action as? SearchEnginesActionType else { return }

        switch action.actionType {
        case SearchEnginesActionType.didTapLoadEnginesButton:
            // IHC - Also, with better typed Actions we won't risk not passing the right info...
            searchEnginesManager.getOrderedEngines { searchEngines in
                let action = SearchEnginesAction(
                    windowUUID: action.windowUUID,
                    actionType: SearchEnginesMiddlewareActionType.didLoadSearchEngines,
                    // Just a rough example of an error
                    loadEnginesResult: searchEngines.isEmpty ? .failure(.emptyResults) : .success(searchEngines)
                )
                store.dispatch(action)
            }

        default:
            break
        }
    }
}
