// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

struct SearchEnginesState: ScreenState, Codable {
    var windowUUID: WindowUUID
    var searchEnginesLoadingState: SearchEnginesLoadingState

    init(appState: AppState, uuid: WindowUUID) {
        guard let state = appState.screenState(
            SearchEnginesState.self,
            for: .searchEngines,
            window: uuid
        ) else {
            self.init(windowUUID: uuid)
            return
        }

        self.init(
            windowUUID: state.windowUUID,
            searchEnginesLoadingState: state.searchEnginesLoadingState
        )
    }

    init(windowUUID: WindowUUID) {
        self.init(
            windowUUID: windowUUID,
            searchEnginesLoadingState: .notStarted
        )
    }

    private init(
        windowUUID: WindowUUID,
        searchEnginesLoadingState: SearchEnginesLoadingState
    ) {
        self.windowUUID = windowUUID
        self.searchEnginesLoadingState = searchEnginesLoadingState
    }

    static func defaultState(from state: SearchEnginesState) -> SearchEnginesState {
        return SearchEnginesState(
            windowUUID: state.windowUUID,
            searchEnginesLoadingState: state.searchEnginesLoadingState
        )
    }

    static let reducer: Reducer<Self> = { state, action in
        // Only process actions for the current window
        guard action.windowUUID == .unavailable || action.windowUUID == state.windowUUID else {
            return defaultState(from: state)
        }

        // IHC - Can we rejigger reducers/middlewares for action creator flows?
        // That would be easier to follow than this:
        // [Action 1] SearchEnginesActionType.didTapLoadEnginesButton
        //              State starts loading
        //              Middleware fires async call via manager
        //                  Middleware gets value via manager and fires next ACTION (didLoadSearchEngines)
        //
        // [Action 2] SearchEnginesMiddlewareActionType.didLoadSearchEngines
        //              State resolves using result of didLoadSearchEngines (success or failure)

        // IHC - How do we do preserveTabs... interrupt preserving when the user closes / undoes closing a tab? (separate action flow)
        // TransitId...
        // C -- part of problem is constantly preserving the tabs. But can we do it less maybe? Edge case where tabs are
        // incorrect is small. It's killing the app / fresh launches is the only time we restore the tabs...
        // Possibly the "tab loss" is an ordering issue between preserving/restoring tabs...
        // isDeeplinkOptimizationRefactorEnabled is ... disabled maybe right now?

        switch action.actionType {
        case SearchEnginesUserActionType.didTapLoadEnginesButton:
            // IHC - Temp logging we can turn on at Redux level when debugging?
            // IHC - Is there a way to return a State with one altered value that is closer to TypeScript?
            return SearchEnginesState(
                windowUUID: state.windowUUID,
                searchEnginesLoadingState: .loading
            )

        case SearchEnginesMiddlewareActionType.didLoadSearchEngines(let result):
            let searchEngineLoadingState: SearchEnginesLoadingState
            switch result {
            case .success(let engines):
                searchEngineLoadingState = .succeeded(engines)
            case .failure(let error):
                searchEngineLoadingState = .failed(error)
            }

            return SearchEnginesState(
                windowUUID: state.windowUUID,
                searchEnginesLoadingState: searchEngineLoadingState
            )

        default:
            return defaultState(from: state)
        }
    }
}
